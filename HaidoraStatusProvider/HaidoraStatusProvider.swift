//
//  HaidoraStatusProvider.swift
//  HaidoraStatusProvider
//
//  Created by Dailingchi on 16/9/9.
//  Copyright © 2016年 Haidora. All rights reserved.
//

import UIKit
import Foundation
import ObjectiveC

/**
 统一HUD的接口方式(可针对该协议做扩展,扩展需要和**HaidoraStatusProvider**配合)
 */
public protocol HaidoraStatusable : class {

    /**
     显示加载动画
     
     - parameter loadingMessage: 加载字符串
     */
    func show(_ loadingMessage: String)
    
    /**
     隐藏加载动画
     
     - parameter delay: 延时时间.0不延时
     */
    func hide(_ delay: TimeInterval)
    
    /**
     隐藏所有的动画
     */
    func hideAll()
}

private struct AssociatedKeys {
    static var statusViews = "HaidoraStatusable_AssociatedKeys_statusViews"
}

extension HaidoraStatusable where Self: AnyObject {
    
    //配置信息
    
    // 默认显示在window上面
    public var onView: UIView {
        return ((UIApplication.shared.delegate?.window)!)!
    }
    
    /// 用于保存当前显示的huds
    public var statusViews: [HaidoraStatusProvider] {
        get {
            var values: [HaidoraStatusProvider]? = objc_getAssociatedObject(self,&AssociatedKeys.statusViews) as? [HaidoraStatusProvider]
            if let values = (objc_getAssociatedObject(self,&AssociatedKeys.statusViews) as? [HaidoraStatusProvider]) {
                return values
            } else {
                let values = [HaidoraStatusProvider]()
                objc_setAssociatedObject(self,&AssociatedKeys.statusViews,values,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return values
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self,&AssociatedKeys.statusViews,newValue,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 用于配置Hud Provider,默认为空
    public var statusProvider: HaidoraStatusProvider.Type? {
        return nil
    }
    
    /**
     显示加载动画
     
     - parameter loadingMessage: 加载字符串
     */
    public func show(_ loadingMessage:String = "loading") {
        let statusView = self.buildProvider()
        statusView.show(loadingMessage, onView: onView)
    }
    
    /**
     隐藏加载动画
     
     - parameter delay: 延时时间.0不延时
     */
    public func hide(_ delay: TimeInterval = 0){
        statusViews.last?.hide(delay)
        statusViews.removeLast()
    }
    
    /**
     隐藏所有的动画
     */
    public func hideAll() {
        statusViews.forEach { (statusView) in
            statusView.hide(0)
        }
    }
    
    /// helper
    public func buildProvider() -> HaidoraStatusProvider {
        var providerType: HaidoraStatusProvider.Type?
        if self.statusProvider == Optional.none {
            providerType = HaidoraStatusConfig.shareInstance.provider
        }
        else {
            providerType = self.statusProvider
        }
        let provider = providerType!.init()
        statusViews.append(provider)
        return provider
    }
}

// HaidoraStatusable - 默认实现
extension HaidoraStatusable where Self: UIViewController {
    
    public var onView: UIView {
        return self.view
    }
}

/**
 *  具体的HUD(MBProgressHUD)需要实现该协议
 
 @see HaidoraStatusable
 */
public protocol HaidoraStatusProvider {
    
    init()
    func show(_ loadingMessage: String, onView: UIView)
    func hide(_ delay: TimeInterval)
}

/// 用于配置默认的HaidoraStatusProvider
open class HaidoraStatusConfig {
    
    open var provider: HaidoraStatusProvider.Type
    
    open class var shareInstance: HaidoraStatusConfig {
        get {
            return Singleton.instance
        }
    }
    
    // MARK: private
    fileprivate init() {
        provider = HaidoraStatusProviderBuildIn.LoadingStatusView.self
    }
    
    fileprivate struct Singleton {
        static let instance = HaidoraStatusConfig()
    }
    
}

internal struct HaidoraStatusProviderBuildIn {
    
    class LoadingStatusView: UIView, HaidoraStatusProvider {
        
        let activityIndicatorView: UIActivityIndicatorView = {
            $0.startAnimating()
            #if os(tvOS)
                $0.activityIndicatorViewStyle = .WhiteLarge
            #elseif os(iOS)
                $0.activityIndicatorViewStyle = .gray
            #endif
            return $0
        }(UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge))

        let loadingLabel: UILabel = {
            $0.text = "Loading…"
            $0.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
            $0.textColor = UIColor.black
            return $0
        }(UILabel())
        
         convenience required init() {
            self.init(frame: CGRect.zero)
            self.autoresizingMask = [UIViewAutoresizing.flexibleHeight,UIViewAutoresizing.flexibleWidth]
            self.addSubview(self.activityIndicatorView)
            self.addSubview(self.loadingLabel)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            self.loadingLabel.sizeToFit()
            self.loadingLabel.center = self.center
            self.activityIndicatorView.frame.origin.x = self.loadingLabel.frame.origin.x - self.activityIndicatorView.frame.size.width
            self.activityIndicatorView.center.y = self.loadingLabel.center.y
        }

        // MARK: HaidoraStatusProvider
        func show(_ loadingMessage: String, onView: UIView) {
            loadingLabel.text = loadingMessage
            onView.addSubview(self)
            self.frame = onView.bounds
        }
        
        func hide(_ delay: TimeInterval) {
            self.removeFromSuperview()
        }
    }
}
