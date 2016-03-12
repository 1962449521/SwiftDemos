//
//  OrderViewController.swift
//  Hungerer
//
//  Created by 胡 帅 on 15/5/21.
//  Copyright (c) 2015年 none. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    @IBOutlet weak var addressTextField:UITextField?
    @IBOutlet weak var phoneTextField:UITextField?
    @IBOutlet weak var orderLable:UILabel?

    var restaurant:Restaurant?
    var dish:Dish?
    var detailInfo:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*"city:\(restaurant?.city),*/
        detailInfo = "restaurant:\(restaurant!.name),dish:\(dish!.name), price:\(dish!.price)"
        var str2 = "dish:\(dish!.name), price:\(dish!.price)"
        orderLable?.text = str2
        let viewClick = UITapGestureRecognizer(target: self, action: "hideKeyBoard")
        viewClick.cancelsTouchesInView = false
        self.view.addGestureRecognizer(viewClick)
        
        var searchResult = DataManager.loadData(nil, entityName: "Profile", sortType: nil)
        if searchResult?.count != 0 {
            var oldProfile = searchResult?.last as! Profile
            addressTextField?.text = oldProfile.address
            phoneTextField?.text = oldProfile.phoneNum
        }

        // Do any additional setup after loading the view.
    }
    
    func hideKeyBoard(){
        addressTextField?.resignFirstResponder()
        phoneTextField?.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        var address = addressTextField?.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        var phoneNum = phoneTextField?.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        if (address == "" || phoneNum == ""){
            UIAlertView(title: "Warning", message: "address and phoneNum cannot be empty", delegate: nil, cancelButtonTitle: "OK").show()
            return false
        }
        return true
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var address = addressTextField?.text
        var phoneNum = phoneTextField?.text
        
        var searchResult = DataManager.loadData(nil, entityName: "Profile", sortType: nil)
        var newProfile:Profile
        if searchResult?.count == 0 {
            newProfile = DataManager.toBeInsertEnitity("Profile") as! Profile
        }
        else{
            newProfile = searchResult?.last as! Profile
        }
        newProfile.address = address!
        newProfile.phoneNum = phoneNum!
        DataManager.saveContext()
        
        var controll = segue.destinationViewController as! SubmitViewController
        controll.profile = newProfile
        controll.detailInfo = self.detailInfo
        
    }
    
}
