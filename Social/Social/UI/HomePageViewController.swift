//
//  HomePageViewController.swift
//  Social
//
//  Created by  on 15/5/18.
//  Copyright (c) 2015年 griffith. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet var webView:UIWebView?
    @IBOutlet var urlTextField:UITextField?
    var urlStr:String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //view.backgroundColor = UIColor.redColor()
        var url = NSURL(string: urlStr!)
        urlTextField?.text = urlStr
       
        
        webView?.loadRequest(NSURLRequest(URL: url!))
        
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
