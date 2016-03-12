//
//  ViewController.swift
//  DrawingBoard
//
//  Created by TomCat on 15-10-10.
//  Copyright (c) 2015年 Disney. All rights reserved.
//

import UIKit

class WorksapceViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    var brushes = [PencilBrush(), LineBrush(), RectangleBrush(), EllipseBrush(), EraserBrush()]
    lazy private var pickerController: UIImagePickerController = {
        [unowned self] in
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        return pickerController
        }()
    
    @IBOutlet var board: Board!
    @IBOutlet var topView: UIView!
    @IBOutlet var toolbar: UIToolbar!
 
    
    var toolbarEditingItems: [UIBarButtonItem]?
    var currentSettingsView: UIView?
    
    @IBOutlet var topViewConstraintY: NSLayoutConstraint!
    @IBOutlet var toolbarConstraintBottom: NSLayoutConstraint!
    @IBOutlet var toolbarConstraintHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.board.brush = brushes[0]
        
        self.toolbarEditingItems = [
            UIBarButtonItem(barButtonSystemItem:.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Hide", style:.Plain, target: self, action: "endSetting")
        ]
        self.toolbarItems = self.toolbar.items

        self.setupBrushSettingsView()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        (self.navigationController)!.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(animated: Bool) {
        AppDelegate.readDataFromLocal()
        self.view.userInteractionEnabled = false
        AppDelegate.readDataFromiCloud { (isSuccess:Bool) -> Void in
            self.view.userInteractionEnabled = true
            if (APPDataSource_iCloud!.drawSource == nil) {
                APPDataSource_iCloud?.drawSource = NSMutableArray(capacity: 0)
            }
        }
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupBrushSettingsView() {
        let brushSettingsView = UINib(nibName: "PaintingBrushSettingsView", bundle: nil).instantiateWithOwner(nil, options: nil).first as! PaintingBrushSettingsView
        
        self.addConstraintsToToolbarForSettingsView(brushSettingsView)
        
        brushSettingsView.hidden = true
        brushSettingsView.tag = 1
        brushSettingsView.backgroundColor = self.board.strokeColor
        
        brushSettingsView.strokeWidthChangedBlock = {
            [unowned self] (strokeWidth: CGFloat) -> Void in
            self.board.strokeWidth = strokeWidth
        }

        brushSettingsView.strokeColorChangedBlock = {
            [unowned self] (strokeColor: UIColor) -> Void in
            self.board.strokeColor = strokeColor
        }
    }
    
    
    func addConstraintsToToolbarForSettingsView(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.toolbar.addSubview(view)
        self.toolbar.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[settingsView]-0-|",
            options: .DirectionLeadingToTrailing,
            metrics: nil,
            views: ["settingsView" : view]))
        self.toolbar.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[settingsView(==height)]",
            options: .DirectionLeadingToTrailing,
            metrics: ["height" : view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height],
            views: ["settingsView" : view]))
    }
    
    func updateToolbarForSettingsView() {
        self.toolbarConstraintHeight.constant = self.currentSettingsView!.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + 44
        
        self.toolbar.setItems(self.toolbarEditingItems, animated: true)
        UIView.beginAnimations(nil, context: nil)
        self.toolbar.layoutIfNeeded()
        UIView.commitAnimations()
        
        self.toolbar.bringSubviewToFront(self.currentSettingsView!)
    }
    

    @IBAction func switchBrush(sender: UISegmentedControl) {
        assert(sender.tag < self.brushes.count, "!!!")
        
        self.board.brush = self.brushes[sender.selectedSegmentIndex]
    }
    
    
    @IBAction func paintingBrushSettings() {
        self.currentSettingsView = self.toolbar.viewWithTag(1)
        self.currentSettingsView?.hidden = false
     
        self.updateToolbarForSettingsView()
    }
    
    
    @IBAction func endSetting() {
        self.toolbarConstraintHeight.constant = 44
        
        self.toolbar.setItems(self.toolbarItems, animated: true)
        
        UIView.beginAnimations(nil, context: nil)
        self.toolbar.layoutIfNeeded()
        UIView.commitAnimations()
        
        self.currentSettingsView?.hidden = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "EditComment") {
            let destinationVC: EditPhotoCommentViewController = segue.destinationViewController as! EditPhotoCommentViewController
            destinationVC.image = self.board.takeImage()
        }
    }
    
    @IBAction func takePhoto(){
        var sheet:UIActionSheet
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            sheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Album","Camera")
        }else{
            sheet = UIActionSheet(title:nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Album")
        }
        sheet.showInView(self.view)
        
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        var sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if(buttonIndex != 0){
            if(buttonIndex==1){
                sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            }else{
                sourceType = UIImagePickerControllerSourceType.Camera
            }
            let imagePickerController:UIImagePickerController = self.pickerController
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = sourceType
            self.presentViewController(imagePickerController, animated: true, completion:nil)
        }
    }
    
    // MARK: UIImagePickerControllerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var image:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        UIGraphicsBeginImageContext(self.view.bounds.size)
        image.drawInRect(self.view.bounds)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
            
        self.board.backgroundColor = UIColor(patternImage: image)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    
}


