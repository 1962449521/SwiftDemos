//
//  FlickrDetailViewController.swift
//  Social
//
//  Created by 胡 帅 on 15/5/20.
//  Copyright (c) 2015年 griffith. All rights reserved.
//

import UIKit

class FlickrDetailViewController: UIViewController {

    @IBOutlet var webView:UIWebView?
    var urlStr:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        var url = NSURL(string: urlStr!)
        
        
        webView?.loadRequest(NSURLRequest(URL: url!))
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
