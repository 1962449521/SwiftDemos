//
//  TwitterTableViewController.swift
//  Social
//
//  Created by 胡 帅 on 15/5/20.
//  Copyright (c) 2015年 griffith. All rights reserved.
//

import UIKit
import Accounts
import Social


class TwitterTableViewController: UITableViewController,NSXMLParserDelegate {

    var identifer:String?
    var dataSource:[TimelineEntry]?
    var strXMLData:String = ""
    var currentElement:String = ""
    var passData:Bool=false
    var passName:Bool=false
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTwitter()
        
    }
    
    func loadTwitter(){
       
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
            let account = ACAccountStore()
            let accountType = account.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
            account.requestAccessToAccountsWithType(accountType, options: nil, completion: { (granted:Bool, error:NSError!) -> Void in
                if granted == true {
                    let arrayOfAccounts = account.accountsWithAccountType(accountType)
                    if arrayOfAccounts.count > 0{
                        let twitterAccount = arrayOfAccounts.last as! ACAccount
                        let requestURL = NSURL(string: "https://api.twitter.com/1/statuses/user_timeline.json")
                        var slRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: requestURL, parameters: [
                            "screen_name" : self.identifer!,
                            "count"       : "5",
                            "exclude_replies" : true])
                        slRequest.account = twitterAccount
                        
                        slRequest.performRequestWithHandler({ (responseData:NSData!, urlReponse:NSHTTPURLResponse!, error:NSError!) -> Void in
                            if (responseData == nil || responseData.length == 0){
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.navigationItem.title = "Twitter"
                                })

                                return
                            }
                            let str = NSString(data: responseData, encoding: NSUTF8StringEncoding)
                            println(str)
                            let loadedData = NSJSONSerialization.JSONObjectWithData(responseData, options: .MutableContainers, error: nil) as! Array<Dictionary<String, AnyObject>>
                            for  aObject:Dictionary<String, AnyObject>  in loadedData{
                                var newItem = TimelineEntry()
                                newItem.text = aObject["text"] as? NSString
                                if  aObject["extended_entities"] != nil{
                                    var extended = aObject["extended_entities"] as! Dictionary<String, AnyObject>
                                    if extended.count > 0{
                                        var media    =  extended["media"] as! Array<Dictionary<String, AnyObject>>
                                        if media.count > 0{
                                            var url = NSURL(string: (media[0]["media_url"] as! String))
                                            var imageData = NSData(contentsOfURL: url!)
                                            if imageData != nil{
                                                newItem.image = UIImage(data: imageData!, scale: 1.0)
                                            }
                                        }
                                    }
                                }
                                if self.dataSource == nil || self.dataSource?.count == 0{
                                    self.dataSource = [newItem]
                                }
                                else{
                                    self.dataSource?.insert(newItem, atIndex: ((self.dataSource?.count)!))
                                }
                                
                            }
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.navigationItem.title = "Twitter"
                                    self.tableView.reloadData()
                                })
                        })
                   }
                }
            })
        }
    }
  
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if self.dataSource != nil{
            return (self.dataSource?.count)!
        }
        else{
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("twitterCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        var timelineEntry = self.dataSource![indexPath.row]
        cell.textLabel?.text = timelineEntry.text as? String

        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let timelineEntry = self.dataSource![indexPath.row]
                let controller = segue.destinationViewController as! TwitterDetailViewController
                controller.detailItem = timelineEntry
     
            }
        }
    }
   
}
