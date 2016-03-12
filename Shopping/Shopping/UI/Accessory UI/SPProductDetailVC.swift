//
//  SPProductDetailVC.swift
//  Shopping
//
//  Created by 胡 帅 on 15/11/29.
//  Copyright © 2015年 Disney. All rights reserved.
//

import UIKit
import CoreData
import BProgressHUD

class SPProductDetailVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblStore: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var txfOrderCount: UITextField!

    
    var product:SPProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = self.product else {
           return
        }
        self.imageView.setWebImage((product?.image)!)
        self.lblStore.text =  "\((product?.stock)!)"
        self.lblPrice.text = "$\((product?.price)!)"
        self.lblCategory.text = product?.category
        self.lblDescription.text = product?.description_
        self.lblDescription.preferredMaxLayoutWidth = self.view.bounds.width - 50
        self.txfOrderCount.text = "1"
        self.txfOrderCount.userInteractionEnabled = false
        self.navigationItem.title = "\((product?.name)!)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func subOrderCount(sender: AnyObject) {
        var curCount:integer_t = (integer_t)(self.txfOrderCount.text!)!
        curCount -= 1
        if (curCount >= 0) {
            self.txfOrderCount.text = "\(curCount)"
        }
    }

    @IBAction func addOrderCount(sender: AnyObject) {
        var curCount:integer_t = (integer_t)(self.txfOrderCount.text!)!
        curCount += 1
        if (curCount <= (integer_t)((self.product?.stock)!)!) {
            self.txfOrderCount.text = "\(curCount)"
        }
    }
    @IBAction func addCount2Cart(sender: AnyObject) {
        let curCount:Int = (Int)(self.txfOrderCount.text!)!

        SPUtil.add2Cart(curCount, product: self.product!) { (isSuccess, eror) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if(isSuccess) {
                    BProgressHUD.showSuccessMessageAutoHide(0.9,msg: "add to cart success")
                } else {
                    BProgressHUD.showErrorMessageAutoHide(0.9,msg: "add to cart fail", dismissBlock: nil)
                }
                
            })
        }
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
