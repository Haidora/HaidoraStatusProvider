//
//  ViewController.swift
//  HaidoraStatusProviderDemo
//
//  Created by Dailingchi on 16/9/9.
//  Copyright © 2016年 Haidora. All rights reserved.
//

import UIKit
import HaidoraStatusProvider

class ViewController: UIViewController,HaidoraStatusPresenter {
    
    var statusViews: [HaidoraStatusProvider] = [HaidoraStatusProvider]()

    override func viewDidLoad() {
        super.viewDidLoad()
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

