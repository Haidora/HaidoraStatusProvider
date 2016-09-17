//
//  HaidoraStatusProvider+MBProgressHUD.swift
//  HaidoraStatusProviderDemo
//
//  Created by Dailingchi on 16/9/12.
//  Copyright © 2016年 Haidora. All rights reserved.
//

import Foundation
import MBProgressHUD

open class  MBProgressHUDSwiftWrap: HaidoraStatusProvider {
    
    var hud: MBProgressHUD?
    
    public required init () {
    }
    
    // MARK: HaidoraStatusProvider
     open func show(_ loadingMessage: String, onView: UIView) {
        self.hud = MBProgressHUD.showAdded(to: onView, animated: true)
        self.hud?.label.text = loadingMessage
    }
    
    open func hide(_ delay: TimeInterval) {
        self.hud?.hide(animated: true, afterDelay: delay)
    }
}
