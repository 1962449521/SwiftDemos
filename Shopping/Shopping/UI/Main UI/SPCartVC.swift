//
//  NEPCartVC.swift
//  Shopping
//
//  Created by 胡 帅 on 15/11/29.
//  Copyright © 2015年 Disney. All rights reserved.
//

import UIKit
import CoreData

class SPCartVC: UIViewController, UITableViewDataSource,UITableViewDelegate {
    var carts_:Array<SPCart> =  Array()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnCheckout: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        let cellIdentifier = "SPCartCell"
        self.tableView.registerNib(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let workerContext = delegate.myCoreDataStack!.newBackgroundWorkerMOC()
        let request = NSFetchRequest(entityName: "CartMO")
        
        workerContext.performBlockAndWait { () -> Void in
            self.carts_.removeAll()
            do {
                let carts = try workerContext.executeFetchRequest(request) as! Array<CartMO>
                for mo:CartMO in carts {
                    let vo = SPCart.init()
                    mo.covert2NormalObject(vo)
                    self.carts_.append(vo)
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if (carts.count == 0) {
                        self.btnCheckout.hidden = true
                    } else {
                        self.btnCheckout.hidden = false
                    }
                    self.tableView.reloadData()
                })
            }
            catch _ {
                
            }
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.carts_.count == 0 ? 1: self.carts_.count
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 70.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (self.carts_.count == 0) {
            var cell = tableView.dequeueReusableCellWithIdentifier("empty")
            if (cell == nil) {
                cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "empty")
                cell?.textLabel?.text = "no any item in cart"
            }
            cell?.selectionStyle = UITableViewCellSelectionStyle.None

            return cell!
        }
        let cellIdentifier = "SPCartCell"
        let cell:SPCartCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SPCartCell
        let cart = self.carts_[indexPath.row]
        cell.imageView_.setWebImage(cart.image!)
        cell.lblName.text = "\(cart.name!)"
        cell.lblPrice.text = "$\(cart.price!)"
        cell.lblCount.text = "x\(cart.count!)"
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cart = self.carts_[indexPath.row]
        let xibIdentifier = "SPProductDetailVC"
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let vc = SPProductDetailVC.init(nibName : xibIdentifier, bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        for product:SPProduct in delegate.products_ {
            if (product.uid == cart.uid) {
                vc.product = product
                break
            }
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func checkout(sender: AnyObject) {
        self.tabBarController?.selectedIndex = 4
    }


    
}
