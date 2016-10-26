//
//  ViewController.swift
//  HaidoraStatusProviderDemo
//
//  Created by Dailingchi on 16/9/9.
//  Copyright © 2016年 Haidora. All rights reserved.
//

import UIKit
import HaidoraStatusProvider

class ViewController: UIViewController, Statusable {
    
//    var statusProvider: StatusProvider.Type? {
//        return MBProgressHUDSwiftWrap.self
//    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        StatusConfig.shareInstance.provider = MBProgressHUDSwiftWrap.self
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    @IBAction func showAction(_ sender: AnyObject) {
        self.show()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.hide()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension Statusable {
    
    public func custom_method() {
        print("上层接口－自定义方法")
        let statusView = self.buildProvider()
        //事件转发到Provider
        statusView.custom_method()
    }
}

extension StatusProvider {
    
    public func custom_method() {
        print("真正实现-自定义方法")
    }
}

extension StatusProvider where Self: MBProgressHUDSwiftWrap {
    public func custom_method() {
        print("某种hud-自定义方法")
    }
}

