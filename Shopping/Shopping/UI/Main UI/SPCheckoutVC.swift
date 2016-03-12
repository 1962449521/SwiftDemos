//
//  SPCheckoutVC.swift
//  Shopping
//
//  Created by 胡 帅 on 15/11/29.
//  Copyright © 2015年 Disney. All rights reserved.
//

import UIKit
import CoreData
import BProgressHUD


class SPCheckoutVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txfCardNum: UITextField!
    @IBOutlet weak var txfPWD: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.btnSubmit.enabled = false
        self.btnSubmit.setTitle("Waiting for Info Input", forState: UIControlState.Normal)
        self.txfCardNum.delegate = self
        self.txfPWD.delegate = self
        
        let rec = UITapGestureRecognizer.init(target: self, action: Selector("dismiss:"))
        self.scrollView.addGestureRecognizer(rec)
        // Do any additional setup after loading the view.
    }
    
    func dismiss(sender:AnyObject?) {
        self.txfCardNum.resignFirstResponder()
        self.txfPWD.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func submit(sender: AnyObject) {
        self.dismiss(nil)
        BProgressHUD.showLoadingView()
        SPUtil.submitCart { (isSuccess, msg) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if(isSuccess) {
                    BProgressHUD.showSuccessMessageAutoHide(0.9, msg: "checkout success", dismissBlock: { () -> Void in
                        self.tabBarController?.selectedIndex = 0
                    })
                    self.txfPWD.text = ""
                    self.txfCardNum.text = ""
                } else {
                    BProgressHUD.showErrorMessageAutoHide(0.9,msg: msg!, dismissBlock: nil)
                }
            })
        }
    }

    @IBAction func txfValueChanged(sender: AnyObject) {
        let strNum = NSString(string:self.txfCardNum.text!)
        let strPWD = NSString(string:self.txfPWD.text!)
        let editable = strNum.length != 0 && strPWD.length != 0
        self.btnSubmit.enabled = editable
        let strTitle = editable ? "Submit":"Waiting for Info Input"
        self.btnSubmit.setTitle(strTitle, forState: UIControlState.Normal)
    }
}
