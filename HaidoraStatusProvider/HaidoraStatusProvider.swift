//
//  HaidoraStatusProvider.swift
//  HaidoraStatusProvider
//
//  Created by Dailingchi on 16/9/9.
//  Copyright © 2016年 Haidora. All rights reserved.
//

import UIKit
import Foundation

/**
 统一HUD的接口方式(可针对该协议做扩展,扩展需要和**HaidoraStatusProvider**配合)
 */
public protocol HaidoraStatusable : class {
    
    /**
     显示加载动画
     
     - parameter loadingMessage: 加载字符串
     */
    func show(loadingMessage: String)
    
    /**
     隐藏加载动画
     
     - parameter delay: 延时时间.0不延时
     */
    func hide(delay: NSTimeInterval)
    
    /**
     隐藏所有的动画
     */
    func hideAll()
}

/**
 为对象添加HUD的能力,需要实现该协议
 
 ```
 class ViewController: UIViewController, HaidoraStatusPresenter {
 
 var statusViews: [HaidoraStatusProvider] = [HaidoraStatusProvider]()
 }
 ```
 */
public protocol HaidoraStatusPresenter : HaidoraStatusable {
    
    /// show where,默认实现
    var onView: UIView { get }
    /// huds,需要实现
    var statusViews: [HaidoraStatusProvider] { get set }
    /// 默认为空
    var statusProvider: HaidoraStatusProvider.Type? { get }
}

// HaidoraStatusPresenter - 默认实现
extension HaidoraStatusPresenter {
    
    // 默认显示在window上面
    public var onView: UIView {
        return ((UIApplication.sharedApplication().delegate?.window)!)!
    }
    
    public var statusProvider: HaidoraStatusProvider.Type? {
        return nil
    }
    
    /**
     显示加载动画
     
     - parameter loadingMessage: 加载字符串
     */
    public func show(loadingMessage:String = "loading") {
        let statusView = self.loadProvider(self.statusProvider).init()
        statusView.show(loadingMessage, onView: onView)
        statusViews.append(statusView)
    }
    
    /**
     隐藏加载动画
     
     - parameter delay: 延时时间.0不延时
     */
    public func hide(delay: NSTimeInterval = 0){
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
    public func loadProvider(provider:HaidoraStatusProvider.Type?) -> HaidoraStatusProvider.Type{
        if provider == Optional.None {
            return HaidoraStatusConfig.shareInstance.provider
        }
        else {
            return provider!
        }
    }
}

// HaidoraStatusPresenter - 默认实现
extension HaidoraStatusPresenter where Self: UIViewController {
    
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
    func show(loadingMessage: String, onView: UIView)
    func hide(delay: NSTimeInterval)
}

/// 用于配置默认的HaidoraStatusProvider
public class HaidoraStatusConfig {
    
    public var provider: HaidoraStatusProvider.Type
    
    public class var shareInstance: HaidoraStatusConfig {
        get {
            return Singleton.instance
        }
    }
    
    // MARK: private
    private init() {
        provider = HaidoraStatusProviderBuildIn.LoadingStatusView.self
    }
    
    private struct Singleton {
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
                $0.activityIndicatorViewStyle = .Gray
            #endif
            return $0
        }(UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge))

        let loadingLabel: UILabel = {
            $0.text = "Loading…"
            $0.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
            $0.textColor = UIColor.blackColor()
            return $0
        }(UILabel())
        
         convenience required init() {
            self.init(frame: CGRectZero)
            self.autoresizingMask = [UIViewAutoresizing.FlexibleHeight,UIViewAutoresizing.FlexibleWidth]
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
        func show(loadingMessage: String, onView: UIView) {
            loadingLabel.text = loadingMessage
            onView.addSubview(self)
            self.frame = onView.bounds
        }
        
        func hide(delay: NSTimeInterval) {
            self.removeFromSuperview()
        }
    }
}