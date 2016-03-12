//
//  SPDiscoveryVC.swift
//  Shopping
//
//  Created by 胡 帅 on 15/11/29.
//  Copyright © 2015年 Disney. All rights reserved.
//

import UIKit
import BProgressHUD
import CoreLocation

class SPFinderVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var stores: Array<Dictionary<String, AnyObject>>? = Array()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let cellIdentifier = "SPStoreCell"
        self.tableView.registerNib(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.automaticallyAdjustsScrollViewInsets = false

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        CLLocationManager().requestWhenInUseAuthorization()
//            && (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways
//                || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse)
        if (CLLocationManager.locationServicesEnabled()) {
            BProgressHUD.showLoadingView()
            let sputil:SPUtil = SPUtil.sharedInstance
            sputil.getGEO { (lati, lgit) -> Void in
                SPUtil.loadStore(lati, lgit: lgit, completionHandler: { (result) -> Void in
                    self.stores = result
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        BProgressHUD.sharedInstance.dismiss()
                        self.tableView.reloadData()
                    })
                })
            }
        } else {
            BProgressHUD.showOnlyMessageAutoHide(0.9, msg: "location Services were disabled", dismissBlock: nil)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stores!.count == 0 ? 1: self.stores!.count
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 90.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (self.stores!.count == 0) {
            var cell = tableView.dequeueReusableCellWithIdentifier("empty")
            if (cell == nil) {
                cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "empty")
                cell?.textLabel?.text = "no any stores found"
            }
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            return cell!
        }
        let cellIdentifier = "SPStoreCell"
        let cell:SPStoreCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SPStoreCell
        let store = self.stores![indexPath.row] as Dictionary<String, AnyObject>
        
        cell.lblNear.text = store["suburb"] as? String
        cell.lblLoc.text = "\(store["street"] as! String), \(store["state"] as! String)"
        cell.lblZip.text = "\(store["postcode"] as! String)"
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }



}
