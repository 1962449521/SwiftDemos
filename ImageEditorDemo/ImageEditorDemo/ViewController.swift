//
//  ViewController.swift
//  ImageEditorDemo
//
//  Created by therealrealvlad on 30/07/2015.
//  Copyright (c) 2015 University of South Australia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    // popoverController
    var popoverImagePicker:UIPopoverController?
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        loadImageFromAssetWithImageName("Glasses_800_edit");
        initializeFilter()
        displayImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Assignment 1-1
    // Define and configure constants, variables and Methods to load and display an image
    // from the source asset folder
    var image4Display: UIImage?
    @IBOutlet weak var imageView: UIImageView!

    private func loadImageFromAssetWithImageName(imageName: String!){
        image4Display = UIImage(named: imageName);
    }
    
    private func displayImage()
    {
        imageView.image = image4Display
    }
    
    // Assignment 1-2
    // Define and configure sliders to allow image editing
    @IBOutlet weak var saturationSlider: UISlider!
    @IBOutlet weak var saturationLabel: UILabel!
    
    // Assignment 1-3
    // Define and configre filters to take input from sliders and update image data accordingly
    var filter = CIFilter(name: "CIColorControls")
    var originalSaturation:Float = 0.0
    
    var originalSharpness:Float = 0.0
    
    private func initializeFilter(){
        filter = CIFilter(name: "CIColorControls")
        filter.setValue(CIImage(image: image4Display), forKey: kCIInputImageKey)
        originalSaturation = filter.valueForKey(kCIInputSaturationKey) as! Float
        saturationSlider.value = originalSaturation
        saturationLabel.text = String(format: "%.2f", saturationSlider.value)
        
        originalSharpness = filter.valueForKey(kCIInputBrightnessKey) as! Float
        brightnessSlider.value = originalSharpness
        brightnessLabel.text = String(format: "%.2f", brightnessSlider.value)
    }
    
    private func setFilterValue(filterValue: Float)
    {
        filter.setValue(filterValue, forKey: kCIInputSaturationKey)
    }
    private func setFilterValueOfSharpness(filterValue: Float)
    {
        filter.setValue(filterValue, forKey: kCIInputBrightnessKey)
    }
    
    private func applyFilter()
    {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let context = CIContext(options: nil)
            var filteredImage = self.filter.outputImage
            let graphicsImage = context.createCGImage(filteredImage, fromRect: filteredImage!.extent)
            self.image4Display = UIImage(CGImage: graphicsImage)
            self.displayImage()
        })
    }
    
    // Assignment 1-4
    // Define and configure buttons to load/save new image 
    // from device Photos library using image picker controller
    
    let types = [UIImagePickerControllerSourceType.PhotoLibrary, UIImagePickerControllerSourceType.Camera];
    let names = ["PhotoLibrary", "Camera"];
    
    @IBAction func loadBtnClick(sender: UIBarButtonItem) {
        let sheet: UIActionSheet = UIActionSheet(title: "Select Photo", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "From \(names[0])", "From \(names[1])")
        
        sheet.showInView(self.view)
    }
    
    @IBAction func saveBtnClick(sender: UIBarButtonItem) {
        UIImageWriteToSavedPhotosAlbum(image4Display, self, "image:didFinishSavingWithError:contextInfo:", nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        let alserMsg = (didFinishSavingWithError != nil) ? "Photo-Save-Failure" : "Photo-Save-Success"
        UIAlertView(title: "Tip", message: "\(alserMsg)!", delegate: nil, cancelButtonTitle: "OK").show()
    }

    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if (buttonIndex == actionSheet.cancelButtonIndex) {
            return;
        } else {
            if (UIImagePickerController.isSourceTypeAvailable(types[buttonIndex-1])){
                if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad) {
                    popoverImagePicker = UIPopoverController(contentViewController: imagePicker)
                    let popoverRect:CGRect =  CGRectMake(0, 0, 320, 568)
                    popoverImagePicker!.popoverContentSize = popoverRect.size
                    
                    popoverImagePicker!.presentPopoverFromRect(popoverRect, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Left, animated: true)
                } else {
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                }
            } else {
                UIAlertView(title: "Warning", message: "\(names[buttonIndex-1]) Unavailable", delegate: nil, cancelButtonTitle: "OK").show()
            }
        }
     }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad) {
            popoverImagePicker!.dismissPopoverAnimated(true)
        } else {
            picker.dismissViewControllerAnimated(true, completion:nil)
        }
        image4Display = info["UIImagePickerControllerOriginalImage"] as? UIImage;
        displayImage()
        initializeFilter()
    }
    
    // Assignment 1-5
    // Define methods to corredctly update image and sliders when switching between sliders, and to reset image and sliders when user desires.
    @IBAction func sliderValueDidChange(sender: UISlider)
    {
        setFilterValue(sender.value)
        saturationLabel.text = String(format: "%.2f", saturationSlider.value)
        applyFilter()
    }
    
    @IBAction func resetApplication(sender: UIButton){
        filter.setValue(originalSaturation, forKey: kCIInputSaturationKey)
        saturationSlider.value = originalSaturation
        saturationLabel.text = String(format: "%.2f", saturationSlider.value)
        applyFilter()
    }
    // Assignment 1-6
    // Define methods to configure UIimage picker controller to work in 
    // popover mode for iPad and modal mode for iPhone
    
    // References Assignment 1-4
    /* 
        if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad) {
        popoverImagePicker = UIPopoverController(contentViewController: imagePicker)
        let popoverRect:CGRect =  CGRectMake(0, 0, 320, 568)
        popoverImagePicker!.popoverContentSize = popoverRect.size

        popoverImagePicker!.presentPopoverFromRect(popoverRect, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Left, animated: true)
        } else {
        self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    */
    
    // Assignment 1-7
    // Style UI display elements using iOS Human Interface Guidelines, and configure storyboard using Auoto-layout
    // to implement rotation and device-type(iPhone, iPad) independence
    
    //  References Main.storyboard



    // Assignment 1-8
    @IBAction func invertColours(sender: UIButton)
    {
        let curSaturation = self.filter.valueForKey(kCIInputSaturationKey) as! Float
        setFilterValue(-curSaturation)
        saturationLabel.text = "\(-curSaturation)"
        applyFilter()
    }

    @IBAction func makeSaturated(sender: UIButton)
    {
        setFilterValue(2.0)
        saturationSlider.value = 2.0
        saturationLabel.text = "2.0"
        applyFilter()
    }
    
    @IBAction func makeGray(sender: UIButton)
    {
        setFilterValue(0.0)
        saturationSlider.value = 0.0
        saturationLabel.text = "0.0"
        applyFilter()
    }
    
    // brightness
    @IBOutlet weak var saturationView: UIView!
    @IBAction func switch2SharpnessView(sender: AnyObject) {
        self.saturationView.hidden = true
    }
    @IBAction func switch2SaturationView(sender: AnyObject) {
        self.saturationView.hidden = false
    }
    
    @IBOutlet weak var brightnessLabel: UILabel!
    @IBOutlet weak var brightnessSlider: UISlider!

    @IBAction func brightnessSliderValueDidChange(sender: UISlider)
    {
        setFilterValueOfSharpness(sender.value)
        brightnessLabel.text = String(format: "%.2f", brightnessSlider.value)
        applyFilter()
    }

    @IBAction func resetSharpness(sender: AnyObject) {
        filter.setValue(originalSharpness, forKey: kCIInputBrightnessKey)
        brightnessSlider.value = originalSharpness
        brightnessLabel.text = String(format: "%.2f", saturationSlider.value)
        applyFilter()
    }
}

