//
//  HaidoraStatusProvider+MBProgressHUD.swift
//  HaidoraStatusProviderDemo
//
//  Created by Dailingchi on 16/9/12.
//  Copyright © 2016年 Haidora. All rights reserved.
//

import Foundation
import MBProgressHUD

public class  MBProgressHUDSwiftWrap: HaidoraStatusProvider {
    
    var hud: MBProgressHUD?
    
    public required init () {
    }
    
    // MARK: HaidoraStatusProvider
     public func show(loadingMessage: String, onView: UIView) {
        self.hud = MBProgressHUD.showHUDAddedTo(onView, animated: true)
        self.hud?.label.text = loadingMessage
    }
    
    public func hide(delay: NSTimeInterval) {
        self.hud?.hideAnimated(true, afterDelay: delay)
    }
}
