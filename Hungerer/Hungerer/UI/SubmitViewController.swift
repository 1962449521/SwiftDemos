//
//  SubmitViewController.swift
//  Hungerer
//
//  Created by 胡 帅 on 15/5/21.
//  Copyright (c) 2015年 none. All rights reserved.
//

import UIKit
import CoreData
import SwiftHTTP
import JSONJoy



class SubmitViewController: UIViewController {

    var profile: Profile?
    var detailInfo:String?

    @IBOutlet weak var addressLabel:UILabel?
    @IBOutlet weak var phoneLabel:UILabel?
    @IBOutlet weak var detailInfoLable:UILabel?

    @IBAction func back2Home(sender:AnyObject){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.leftBarButtonItem = nil
        addressLabel?.text = profile?.address
        phoneLabel?.text = profile?.phoneNum
        detailInfoLable?.text = detailInfo
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // submit order
    @IBAction func submitOrder(sender:AnyObject){
        self.navigationItem.title = "Submit(Processing...)"
        let request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        var paras = ["address":profile?.address, "phoneNum":profile?.phoneNum, "detail" : detailInfo]
      
        request.POST(ORDER_CREATE, parameters: nil, success: ({ (response:HTTPResponse) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.navigationItem.title = "submit"
            })
            let responseObject = (JSONDecoder(response.responseObject!)).dictionary
            let resultJsonCoders = responseObject!["result"]?.dictionary
            if (resultJsonCoders != nil ) {
                println("\(resultJsonCoders)")
                var isSuccess =  resultJsonCoders!["isSuccess"]!.bool
                if (isSuccess){
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        UIAlertView(title: "Success", message: "submit successed", delegate: nil, cancelButtonTitle: "OK").show()
                    })
                }
                
            }
            else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        UIAlertView(title: "Warning", message: "submit failed", delegate: nil, cancelButtonTitle: "OK").show()
                    })
            }
            
        }), failure: (
            {(b:NSError,c:HTTPResponse?) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    UIAlertView(title: "Warning", message: "submit failed", delegate: nil, cancelButtonTitle: "OK").show()
            })
            
            return
            }
        ))
        
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
