//
//  FlickrTableViewController.swift
//  Social
//
//  Created by 胡 帅 on 15/5/20.
//  Copyright (c) 2015年 griffith. All rights reserved.
//

import UIKit

let flickrApiKey = "7440972f97c9996fbe2559357e735326"
//let searchUserName = "Stewart"

class FlickrTableViewController: UITableViewController {

    var searchUserName: String?
    var titles:[String] = []
    var photoURLs:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFlickr()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func loadFlickr(){
        
        
        let baseURL = "https://api.flickr.com/services/rest/?"
        let methodStr1 = "&method=flickr.people.findByUsername"
        let methodStr2 = "&method=flickr.people.getPublicPhotos"
        let methodStr3 = "&method=flickr.photos.getInfo"
        let apiStr = "&api_key=\(flickrApiKey)"
        let searchNameStr = "&username=\(searchUserName!)"
        let pageStr   = "&per_page=5"
        let requestURL1 = NSURL(string: baseURL + methodStr1 + apiStr + searchNameStr)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(requestURL1!, completionHandler: { responseData, response, error -> Void in
            
            if (responseData == nil || responseData.length == 0) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.navigationItem.title = "Flickr"
                })
                return
            }
            var error: NSError?
            if let xmlDoc = AEXMLDocument(xmlData: responseData, error: &error) {
                println(xmlDoc.xmlString)
                let attributes = xmlDoc.root["user"].attributes as! Dictionary<String, AnyObject>
                if attributes["nsid"] == nil{
                    return
                }
                let nsid       = attributes["nsid"] as! String
                print(nsid)
                let searchIdStr = "&user_id=\(nsid)"
                
                let requestURL2 = NSURL(string: baseURL + methodStr2 + apiStr + searchIdStr + pageStr)
                
                let subTask = session.dataTaskWithURL(requestURL2!, completionHandler: { (responseData2, response2, error2) -> Void in
                    if (responseData2 == nil || responseData2.length == 0) {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.navigationItem.title = "Flickr"
                        })
                        return
                    }
                    if let xmlDoc = AEXMLDocument(xmlData: responseData2, error: &error) {
                        println(xmlDoc.xmlString)
                        var photoIds:[String] = []
                        
                        for photo:AEXMLElement in xmlDoc.root["photos"].children{
                            photoIds.insert( (photo.attributes["id"]) as! String, atIndex:photoIds.count)
                            //self.titles.insert( (photo.attributes["title"]) as! String, atIndex:self.titles.count)
                            
                        }
                        println("\(photoIds)")
                        println("\(self.titles)")
                        //var requestURL3:NSURL!
                        var searchPhotoStr:String!
                        var photoTask:NSURLSessionDataTask!
                        var requestURL3:NSURL!
                        for photoId in photoIds{
                            searchPhotoStr = "&photo_id=\(photoId)"
                            var fulStr = baseURL + methodStr3 + apiStr + searchPhotoStr
                            println(fulStr)
                            requestURL3 = NSURL(string:fulStr )!
                            photoTask = session.dataTaskWithURL(requestURL3, completionHandler: { (responseData3, response3, error3) -> Void in
                                if (responseData3 == nil || responseData3.length == 0) {
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        self.navigationItem.title = "Flickr"
                                    })
                                    return
                                }
                                if let xmlDoc = AEXMLDocument(xmlData: responseData3, error: &error) {
                                    println(xmlDoc.xmlString)
                                    var title = xmlDoc.root["photo"]["title"].value
                                    self.titles.insert( title!, atIndex:self.titles.count)
                                    var url = xmlDoc.root["photo"]["urls"]["url"].value
                                    self.photoURLs.insert( url!, atIndex:self.photoURLs.count)
                                }
                                if self.photoURLs.count == photoIds.count{
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        self.navigationItem.title = "Flickr"
                                        self.tableView.reloadData()
                                    });
                                    
                                }
                            })
                            photoTask.resume()
                        }
                        
                    }
                    
                })
                subTask.resume()
                
                
                
            }
            
        })
        
        task.resume()
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
        return self.titles.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("flickrCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = self.titles[indexPath.row]
        return cell
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let url = self.photoURLs[indexPath.row]
                let controller = segue.destinationViewController as! FlickrDetailViewController
                controller.urlStr = url
                
            }
        }
    }


}
