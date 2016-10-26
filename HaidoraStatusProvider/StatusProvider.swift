/**
 *  具体的HUD(MBProgressHUD)需要实现该协议
 
 @see Statusable
 */
public protocol StatusProvider {
    
    init()
    /// @see Statusable.show
    func show(_ loadingMessage: String, onView: UIView)
    /// @see Statusable.hide
    func hide(_ delay: TimeInterval)
}

/// 用于配置默认的HaidoraStatusProvider
public class StatusConfig {
    
    /// HUD提供者
    public var provider: StatusProvider.Type
    
    public class var shareInstance: StatusConfig {
        get {
            return Singleton.instance
        }
    }
    
    // MARK: private
    fileprivate init() {
        provider = StatusProviderBuildIn.LoadingStatusView.self
    }
    
    fileprivate struct Singleton {
        static let instance = StatusConfig()
    }
    
}

fileprivate struct StatusProviderBuildIn {
    
    class LoadingStatusView: UIView, StatusProvider {
        
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
            self.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
            self.frame = onView.bounds
        }
        
        func hide(_ delay: TimeInterval) {
            self.removeFromSuperview()
        }
    }
}
