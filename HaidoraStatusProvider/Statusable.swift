import UIKit
import Foundation
import ObjectiveC

/**
 统一HUD的接口方式(可针对该协议做扩展,扩展需要和**StatusProvider**配合)
 */
public protocol Statusable : class {
    
    /// status显示在哪里
    var statusOnView: UIView { get }
    
    /// 用于配置Hud Provider,默认为空
    var statusProvider: StatusProvider.Type? { get }
}

// MARK: HaidoraStatusable-DefaultImp
extension Statusable {
    
    /// 默认显示在window上面
    public var statusOnView: UIView {
        return ((UIApplication.shared.delegate?.window)!)!
    }
    
    /// 用于配置Hud Provider,默认为空
    public var statusProvider: StatusProvider.Type? {
        return nil
    }
}

extension Statusable where Self: UIViewController {
    
    public var statusOnView: UIView {
        return self.view
    }
}

private struct AssociatedKeys {
    static var statusViews = "HaidoraStatusable_AssociatedKeys_statusViews"
}

// MARK: HaidoraStatusable-convenience
extension Statusable {

    /// 用于保存当前显示的huds
    public var statusViews: [StatusProvider] {
        get {
            if let values = (objc_getAssociatedObject(self,&AssociatedKeys.statusViews) as? [StatusProvider]) {
                return values
            } else {
                let values = [StatusProvider]()
                objc_setAssociatedObject(self,&AssociatedKeys.statusViews,values,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return values
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self,&AssociatedKeys.statusViews,newValue,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// helper
    public func buildProvider() -> StatusProvider {
        var providerType: StatusProvider.Type?
        if self.statusProvider == Optional.none {
            providerType = StatusConfig.shareInstance.provider
        }
        else {
            providerType = self.statusProvider
        }
        let provider = providerType!.init()
        statusViews.append(provider)
        return provider
    }
    
    /**
     显示加载动画
     
     - parameter loadingMessage: 加载字符串
     */
    public func show(_ loadingMessage:String = "loading") {
        let statusView = self.buildProvider()
        statusView.show(loadingMessage, onView: statusOnView)
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
}
