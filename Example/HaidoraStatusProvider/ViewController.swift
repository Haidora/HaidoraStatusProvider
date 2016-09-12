//
//  ViewController.swift
//  HaidoraStatusProviderDemo
//
//  Created by Dailingchi on 16/9/9.
//  Copyright © 2016年 Haidora. All rights reserved.
//

import UIKit
import HaidoraStatusProvider

class ViewController: UIViewController,HaidoraStatusable {
    
    var statusProvider: HaidoraStatusProvider.Type? {
        return MBProgressHUDSwiftWrap.self
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        HaidoraStatusConfig.shareInstance.provider = MBProgressHUDSwiftWrap.self
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    @IBAction func showAction(sender: AnyObject) {
        self.show()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.hide()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HaidoraStatusable {
    
    public func custom_method() {
        print("上层接口－自定义方法")
        let statusView = self.buildProvider()
        //事件转发到Provider
        statusView.custom_method()
    }
}

extension HaidoraStatusProvider {
    
    public func custom_method() {
        print("真正实现-自定义方法")
    }
}

extension HaidoraStatusProvider where Self: MBProgressHUDSwiftWrap {
    public func custom_method() {
        print("某种hud-自定义方法")
    }
}

