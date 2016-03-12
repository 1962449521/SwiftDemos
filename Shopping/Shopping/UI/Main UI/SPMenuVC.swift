//
//  MenuViewController.swift
//  Shopping
//
//  Created by 胡 帅 on 15/11/29.
//  Copyright © 2015年 Disney. All rights reserved.
//

import UIKit
import CoreData
import BProgressHUD

class SPMenuVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var products_:Array<SPProduct> =  Array()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellIdentifier = "SPProductCell"
        self.tableView.registerNib(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(animated: Bool) {
        BProgressHUD.showLoadingView()
        SPUtil.loadStoreInfoCompleted { (isSuccess, eror) -> Void in
            BProgressHUD.sharedInstance.dismiss()
            if (!isSuccess) {
                let errorStr = eror!.userInfo[NSLocalizedDescriptionKey]
            } else {
                let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let workerContext = delegate.myCoreDataStack!.mainQueueContext
                
                workerContext.performBlock() {
                    let request = NSFetchRequest(entityName: "ProductMO")
                    do {
                        let products = try workerContext.executeFetchRequest(request) as! Array<ProductMO>
                        for mo:ProductMO in products {
                            let vo = SPProduct.init()
                            mo.covert2NormalObject(vo)
                            self.products_ .append(vo)
                        }
                        delegate.products_ = self.products_
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.tableView.reloadData()
                        })
                    }
                    catch _ {
                    }
                }
            }
            
        }
        
        super.viewWillAppear(animated)
    }

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products_.count
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellIdentifier = "SPProductCell"
        let cell:SPProductCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! SPProductCell
        
        let product = self.products_[indexPath.row]
        cell.lblDescription.text = product.description_
        cell.lblDescription.preferredMaxLayoutWidth = self.view.bounds.width - 75

        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        let height = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        
        return height
         }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "SPProductCell"
        let cell:SPProductCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SPProductCell
        let product = self.products_[indexPath.row]
        cell.imageView_.setWebImage(product.image!)
        cell.lblName.text = "\(product.name!)(SK:\(product.stock!))"
        
        
        cell.lblDescription.text = product.description_
        cell.lblDescription.preferredMaxLayoutWidth = self.view.bounds.width - 75

        cell.lblPrice.text = "$\(product.price!)"
        cell.btnAdd.tag = indexPath.row
        cell.btnAdd.addTarget(self, action: Selector("add2cart:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        return cell
    }

    func add2cart(sender:UIButton){
        let index = sender.tag
        let product = self.products_[index] as SPProduct
        SPUtil.add2Cart(1,product: product) { (isSuccess, eror) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if(isSuccess) {
                    BProgressHUD.showSuccessMessageAutoHide(0.9,msg: "add to cart success")
                } else {
                    BProgressHUD.showErrorMessageAutoHide(0.9,msg: "add to cart fail", dismissBlock: nil)
                }

            })
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let xibIdentifier = "SPProductDetailVC"

        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let vc = SPProductDetailVC.init(nibName : xibIdentifier, bundle: nil)
        vc.hidesBottomBarWhenPushed = true

        vc.product = self.products_[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
