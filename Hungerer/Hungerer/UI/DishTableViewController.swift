//
//  DishTableViewController.swift
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


class DishTableViewController: UITableViewController {

    weak var restaurant:Restaurant?
    var dataSourse:[Dish] = [Dish]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = (self.restaurant?.name)!
        var dishesOfRestaurant = self.restaurant!.dishes as NSSet
        if dishesOfRestaurant.count > 0 {
            for dish in dishesOfRestaurant{
                self.dataSourse.append(dish as! Dish)
            }
            self.dataSourse.sort({
                $0.id.compare($1.id, options: NSStringCompareOptions.LiteralSearch, range: nil, locale: nil) == NSComparisonResult.OrderedAscending
            })
            self.tableView.reloadData()
        }
        else{
            dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
                self.loadData(self.restaurant?.id)
            })
        }
    }
    @IBAction func refresh(sender:AnyObject){
        dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
            var str = self.restaurant?.id
            self.loadData(str)
            
        })
        
        
    }
    // MARK: - Load Data
    func loadData(restaurantId: String?){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.navigationItem.title = "\((self.restaurant?.name)!)(loading)"
        })
       
        let request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        var qureyURLStr = MENU_SHOW + "?restaurantId=\(restaurantId!)"
        qureyURLStr = qureyURLStr.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        println("queryURLStr:\(qureyURLStr)")
        request.GET(qureyURLStr, parameters: nil, success: ({ (response:HTTPResponse) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.navigationItem.title = (self.restaurant?.name)!
            })
            let responseObject = (JSONDecoder(response.responseObject!)).dictionary
            let resultJsonCoders = responseObject!["result"]?.array
            if (resultJsonCoders != nil && resultJsonCoders?.count > 0) {
                var newDataSource:[Dish] = [Dish]()
                for  jsonCoder in resultJsonCoders!{
                    let aDish = DishStruct(jsonCoder)
                    let id = aDish.id!
                    
                    var str:String = "id=="+"\"\(id)\""
                    var predicate = NSPredicate(format: str)
                    var searchResult = DataManager.loadData(predicate, entityName: "Dish", sortType: nil)
                    var dish:Dish
                    if searchResult?.count > 0 {
                        dish = searchResult!.last as! Dish
                        var dishId = dish.id
                        var isExisted = false
                        var dishesOfRestaurant = self.restaurant!.dishes as NSSet
                        for existedDish in dishesOfRestaurant{
                            if existedDish.id == dishId {
                                isExisted = true
                            }
                        }
                        if !isExisted {
                            self.restaurant!.addDishObject(dish)
                        }
                    }
                    else {
                        dish = DataManager.toBeInsertEnitity("Dish") as! Dish
                        
                        self.restaurant!.addDishObject(dish)
                    }
                    dish.id = aDish.id!
                    dish.name = aDish.name!
                    dish.price = aDish.price!
                    dish.photoURL = aDish.photoURL!
                    newDataSource.append(dish)
                }
                self.dataSourse = newDataSource
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.navigationItem.title = (self.restaurant?.name)!
                    DataManager.saveContext()
                    self.dataSourse.sort({
                        $0.id.compare($1.id, options: NSStringCompareOptions.LiteralSearch, range: nil, locale: nil) == NSComparisonResult.OrderedAscending
                    })
                    self.tableView?.reloadData()
                })
            }
            else if (resultJsonCoders == nil){
                let error = responseObject!["error"]?.string
                if (error != nil){
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        UIAlertView(title: "Warning", message: error, delegate: nil, cancelButtonTitle: "OK").show()
                    })
                    
                }
            }
            else if resultJsonCoders?.count == 0{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    UIAlertView(title: "Warning", message: "no dishes found in \(restaurantId)", delegate: nil, cancelButtonTitle: "OK").show()
                })
            }
            
        }), failure: ({(b:NSError,c:HTTPResponse?) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                UIAlertView(title: "Warning", message: b.description, delegate: nil, cancelButtonTitle: "OK").show()
            })
            
            return
        })
        )
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
        return self.dataSourse.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dishCell", forIndexPath: indexPath) as! DishTableViewCell
        let imageURL = self.dataSourse[indexPath.row].photoURL
        let fullImageURL = "\(PREFIX_DISH_IMAGEURL)\(imageURL)"
        println(fullImageURL)
        cell.dishImageView?.loadImageFromURLString(fullImageURL, placeholderImage: UIImage(named: "defaultImage.png"), completion: { (finished, error) -> Void in
            return//cell.brandImageView?.image = finished
        })
        cell.nameLabel?.text = self.dataSourse[indexPath.row].name
        cell.priceLabel?.text = "\(self.dataSourse[indexPath.row].price)"

        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var controll = segue.destinationViewController as! OrderViewController
        if let indexPath = self.tableView!.indexPathForSelectedRow() {
            controll.restaurant = self.restaurant
            controll.dish = self.dataSourse[indexPath.row]
        }
    }

}
