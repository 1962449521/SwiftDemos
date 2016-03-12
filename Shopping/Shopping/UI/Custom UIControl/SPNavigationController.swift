//
//  SPNavigationController.swift
//  Shopping
//
//  Created by 胡 帅 on 15/11/28.
//  Copyright © 2015年 Disney. All rights reserved.
//

import UIKit

class SPNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let titleColor = UIColor(red: 0, green: 126.0/255.0, blue: 0, alpha: 1)
        let bgColor = UIColor(white: 240.0/255.0, alpha: 1)
        self.navigationBar.barTintColor = bgColor
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:titleColor]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
