//
//  DetailViewController.swift
//  Social
//
//  Created by  on 15/5/17.
//  Copyright (c) 2015年 griffith. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController,UITextFieldDelegate {

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var fistNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var twitterIdTextField: UITextField!
    @IBOutlet weak var flickrIdTextField: UITextField!
    @IBOutlet weak var homePageSiteTextField: UITextField!
    @IBOutlet weak var photoURLTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!



    weak var detailItem: Contact? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: Contact = self.detailItem {
            if (addressTextField != nil){
                addressTextField.text = detail.address! as String
                fistNameTextField.text = detail.firstName! as String
                lastNameTextField.text = detail.lastName! as String
                twitterIdTextField.text = ((detail.sites![0]).identifier)! as String
                flickrIdTextField.text = ((detail.sites![1]).identifier)! as String
                homePageSiteTextField.text = ((detail.sites![2]).identifier)! as String
                photoURLTextField.text = detail.imageURL! as String
                photoImageView.image   = detail.image
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "insertNewObject:")
        self.configureView()
        let tableViewClick = UITapGestureRecognizer(target: self, action: "hideKeyBoard")
        tableViewClick.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tableViewClick)
    }
    
    func hideKeyBoard(){
        addressTextField.resignFirstResponder()
        fistNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        twitterIdTextField.resignFirstResponder()
        flickrIdTextField.resignFirstResponder()
        homePageSiteTextField.resignFirstResponder()
        photoURLTextField.resignFirstResponder()
    }
    
    func insertNewObject(sender: AnyObject) {
        var newContact:Contact = Contact()
        if (contacts != nil){
            contacts!.insert(newContact, atIndex: 0)
        }
        else{
            contacts = [newContact]
        }
        self.detailItem = contacts![0]
        configureView()

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if(section == 0){
            return 1.0
        }
        else{
            return 40.0
        }
    }

    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier!{
            
        case "showAddress":
            let adressController = segue.destinationViewController  as! AddressViewController
            adressController.address = addressTextField.text
        case "showHomePage":
            let homepageController = segue.destinationViewController  as! HomePageViewController
            homepageController.navigationItem.title = detailItem!.firstName! as String + " " + (detailItem!.lastName! as String) as String + "'s Homepage"
            homepageController.urlStr = homePageSiteTextField.text
        case "showTwitter":
            let twitterController = segue.destinationViewController as! TwitterTableViewController
            //twitterController.navigationItem.title = twitterIdTextField.text + "'s twitter"
            twitterController.identifer = twitterIdTextField.text
        case "showFlickr":
            let twitterController = segue.destinationViewController as! FlickrTableViewController
            //twitterController.navigationItem.title = twitterIdTextField.text + "'s twitter"
            twitterController.searchUserName = flickrIdTextField.text

        default:
            let doNoting = 0
        }
    }
    
    // MARK: - UITextFiledDelegate
    func textFieldDidEndEditing(textField: UITextField){
        switch textField.tag{
        case 0:
            detailItem?.firstName = textField.text
        case 1:
            detailItem?.lastName = textField.text
        case 2:
            detailItem?.address  = textField.text
        case 3:
            var site = detailItem?.sites![0]
            site?.identifier =  textField.text
        case 4:
            var site = detailItem?.sites![1]
            site?.identifier =  textField.text
        case 5:
            var site = detailItem?.sites![2]
            site?.identifier =  textField.text
        case 6:
            detailItem?.imageURL = textField.text
            var url = NSURL(string: textField.text)
            var imageData = NSData(contentsOfURL: url!)
            if imageData != nil{
                var image = UIImage(data: imageData!, scale: 1.0)
                if image != nil{
                    detailItem?.image = image
                    photoImageView.image = image
                }
            }
            
        default:
            let donothing = 0
        }
    }
    


}

