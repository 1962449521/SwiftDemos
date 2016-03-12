//
//  ViewController.swift
//  Hungerer
//
//  Created by 胡 帅 on 15/5/21.
//  Copyright (c) 2015年 none. All rights reserved.
//

import UIKit
import CoreData
import SwiftHTTP
import JSONJoy
import KFSwiftImageLoader

class MainVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {

    var dataSourse:[Restaurant] = [Restaurant]()
    @IBOutlet weak var searchBar:UISearchBar?
    @IBOutlet weak var tableView:UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var sortDiscriptor = NSSortDescriptor(key: "id", ascending: true)
        var sortDiscriptors = [sortDiscriptor]
        var searchResult = DataManager.loadData(nil, entityName: "Restaurant", sortType: sortDiscriptors)
        if searchResult?.count > 0 {
            self.dataSourse = searchResult as! [Restaurant]
            self.tableView?.reloadData()
        }
        else{
        dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
            self.loadData("")
        })
        }
   
  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refresh(sender:AnyObject){
        dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
            var str = self.searchBar?.text
            self.loadData(str!)
        })
    }
    // MARK: - Load Data
    func loadData(cityName: String){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.navigationItem.title = "hungerer(loading)"
        })
        
        let request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        var qureyURLStr = RESTAURANT_SHOW + "?city=\(cityName)"
        qureyURLStr = qureyURLStr.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
    
        request.GET(qureyURLStr, parameters: nil, success: ({ (response:HTTPResponse) -> Void in
            let responseObject = (JSONDecoder(response.responseObject!)).dictionary
            let resultJsonCoders = responseObject!["result"]?.array
            if (resultJsonCoders != nil && resultJsonCoders?.count > 0) {
                var newDataSource:[Restaurant] = [Restaurant]()
                for  jsonCoder in resultJsonCoders!{
                    let aRestaurant = RestaurantStruct(jsonCoder)
                    let id = aRestaurant.id
                    
                    var str:String = "id=="+"\"\(id)\""
                    var predicate = NSPredicate(format: str)
                    var searchResult = DataManager.loadData(predicate, entityName: "Restaurant", sortType: nil)
                    var restaurant:Restaurant
                    if searchResult?.count > 0 {
                        restaurant = searchResult!.last as! Restaurant
                    }
                    else {
                        restaurant = DataManager.toBeInsertEnitity("Restaurant") as! Restaurant
                    }
                    restaurant.id = aRestaurant.id
                    restaurant.name = aRestaurant.name
                    restaurant.city = aRestaurant.city
                    restaurant.photoURL = aRestaurant.photoURL
                    newDataSource.append(restaurant)
                }
                self.dataSourse = newDataSource
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.navigationItem.title = "hungerer"

                    self.tableView?.reloadData()
                })
            }
            else if (resultJsonCoders == nil){
                let error = responseObject!["error"]?.string
                if (error != nil){
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.navigationItem.title = "hungerer"

                        UIAlertView(title: "Warning", message: error, delegate: nil, cancelButtonTitle: "OK").show()
                    })

                }
            }
            else if resultJsonCoders?.count == 0{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.navigationItem.title = "hungerer"

                        UIAlertView(title: "Warning", message: "no restaurants found in \(cityName)", delegate: nil, cancelButtonTitle: "OK").show()
                    })

            }

        }), failure: ({(b:NSError,c:HTTPResponse?) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.navigationItem.title = "hungerer"

                    UIAlertView(title: "Warning", message: b.description, delegate: nil, cancelButtonTitle: "OK").show()
                })

            return
        })
        )
        
    }


    
    // MARK: - UITableView
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.dataSourse.count
    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("restaurantCell", forIndexPath: indexPath) as! RestaurantTableViewCell
//        ImageLoader.sharedLoader.imageForUrl(urlString, completionHandler:{(image: UIImage?, url: String) in
//            self.imageView.image = image
//        }) 
        let imageURL = self.dataSourse[indexPath.row].photoURL
        let fullImageURL = "\(PREFIX_RESTAURANT_IMAGEURL)\(imageURL)"
        println(fullImageURL)
        cell.brandImageView?.loadImageFromURLString(fullImageURL, placeholderImage: UIImage(named: "defaultImage.png"), completion: { (finished, error) -> Void in
            return//cell.brandImageView?.image = finished
        })
        cell.nameLabel?.text = self.dataSourse[indexPath.row].name
        cell.cityLabel?.text = self.dataSourse[indexPath.row].city
        
    
        return cell
    }
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
            var str = self.searchBar?.text
            //str = str!.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
            self.loadData(str!)
            
        })
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar){
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var controll = segue.destinationViewController as! DishTableViewController
        if let indexPath = self.tableView!.indexPathForSelectedRow() {
            controll.restaurant = self.dataSourse[indexPath.row]
        }
    }


}

