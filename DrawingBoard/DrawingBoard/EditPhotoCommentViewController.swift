//
//  EditPhotoCommentViewController.swift
//  DrawingBoard
//
//  Created by TomCat on 15-10-10.
//  Copyright (c) 2015年 Disney. All rights reserved.
//

import UIKit
import Foundation

class EditPhotoCommentViewController: UIViewController, UIActionSheetDelegate {
    var image:UIImage?
    
    @IBOutlet weak var textFiled: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.setNavigationBarHidden(false, animated: false)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "save")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
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
    
    func save() {
        self.textFiled.resignFirstResponder()
        
            let actionSheet = UIActionSheet(title: "Save to", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
            
            actionSheet.addButtonWithTitle("Local")
            actionSheet.addButtonWithTitle("iCloud")
            actionSheet.addButtonWithTitle("Both")
            actionSheet.showInView(self.view);
        
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if let err = error {
            UIAlertView(title: "Error", message: err.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
        } else {
            UIAlertView(title: "Tip", message: "Save Success", delegate: nil, cancelButtonTitle: "OK").show()
        }
    }
    func saveToAlbum() {
        UIImageWriteToSavedPhotosAlbum(self.image!, self, "image:didFinishSavingWithError:contextInfo:", nil)
    }

    
    // MARK: - UIActionSheetDelegate
     func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        switch buttonIndex{
        case 0:
            NSLog("%s", "nothing1")
        case 1:
            self.save2Local()
            self.navigationController!.popViewControllerAnimated(true)

        case 2:
            self.save2iCloud()
        case 3:
            self.save2Local()
            self.save2iCloud()
        default:
            NSLog("%s", "nothing3")
        }
        
    }
    func save2Local(){
        let drawModel:DrawModel = DrawModel(image: self.image, comment: self.textFiled.text)
        APPDataSource_Local!.addObject(drawModel)
        AppDelegate.saveDataToLocal()
    }
    func save2iCloud(){
        let drawModel:DrawModel = DrawModel(image: self.image, comment: self.textFiled.text)
        APPDataSource_iCloud!.drawSource!.addObject(drawModel)
        self.view.userInteractionEnabled = false
        AppDelegate.saveDataToiCloud { (isSuccess:Bool) -> Void in
            self.view.userInteractionEnabled = true
            if (isSuccess){
                UIAlertView(title: "tip", message: "icloud save success", delegate: nil, cancelButtonTitle: "ok").show()
            } else {
                UIAlertView(title: "tip", message: "icloud save fail", delegate: nil, cancelButtonTitle: "ok").show()
            }
            self.navigationController!.popViewControllerAnimated(true)
        }
    
    }

}
