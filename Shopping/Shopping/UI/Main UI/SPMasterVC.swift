//
//  MasterViewController.swift
//  Shopping
//
//  Created by 胡 帅 on 15/11/28.
//  Copyright © 2015年 Disney. All rights reserved.
//

import UIKit
import CoreLocation

class SPMasterVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SPUtil.sharedInstance.getGEO { (lati, lgit) -> Void in
        }
    }
    
       
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
   
}
