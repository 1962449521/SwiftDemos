//
//  CVInfoView.swift
//  demo
//
//  Created by Mitty on 16/1/31.
//  Copyright © 2016年 Mitty. All rights reserved.
//

import UIKit

class CVInfoView: UIView {
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var cstInfoViewLeading: NSLayoutConstraint!
    
    static func InfoViewWithMessage(msg:String, leading:CGFloat) -> CVInfoView{
        let infoView = NSBundle.mainBundle().loadNibNamed("CVInfoView", owner: nil, options: nil).first as! CVInfoView
        infoView.lblMessage.text = msg
        infoView.cstInfoViewLeading.constant = leading
        return infoView
    }
    
    @IBAction func infoViewClicked(sender: UIButton) {
        NSLog("Info view clicked!")
    }
  
    
}
