//
//  TwitterDetailViewController.swift
//  Social
//
//  Created by 胡 帅 on 15/5/20.
//  Copyright (c) 2015年 griffith. All rights reserved.
//

import UIKit

class TwitterDetailViewController: UIViewController {
    weak var detailItem: TimelineEntry?
    @IBOutlet weak var textLabel: UILabel?
    @IBOutlet weak var imageView: UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if detailItem != nil{
            textLabel?.text = detailItem?.text as? String
            textLabel?.sizeToFit()
            if detailItem?.image != nil{
                imageView?.image = detailItem?.image
                var rect = imageView!.frame
                rect.origin.y = textLabel!.frame.origin.y + textLabel!.frame.size.height + 5.0
                imageView?.frame = rect
                
            }
        }

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
