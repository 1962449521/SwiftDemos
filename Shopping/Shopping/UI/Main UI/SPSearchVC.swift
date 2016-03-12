//
//  SPSearchVC.swift
//  Shopping
//
//  Created by 胡 帅 on 15/11/29.
//  Copyright © 2015年 Disney. All rights reserved.
//

import UIKit
import CoreData
import BProgressHUD

class SPSearchVC: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var products_:Array<SPProduct> =  Array()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        let cellIdentifier = "SPProductCell"
        self.tableView.registerNib(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
        let rec = UITapGestureRecognizer.init(target: self, action: Selector("dismiss:"))
        rec.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(rec)
    }
    
    // Do any additional setup after loading the view.

    func dismiss(sender:AnyObject) {
        self.setEditing(false, animated: false)
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
        self.searchBar.resignFirstResponder()
        let xibIdentifier = "SPProductDetailVC"
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let vc = SPProductDetailVC.init(nibName : xibIdentifier, bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        
        vc.product = self.products_[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func searchBarSearchButtonClicked(searchbar:UISearchBar) {
        searchbar.resignFirstResponder()
        
        self.products_.removeAll()
        let keyWord = searchbar.text
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        for product:SPProduct in delegate.products_ {
            if (product.name!.uppercaseString.containsString(keyWord!.uppercaseString) ||
                product.description_!.uppercaseString.containsString(keyWord!.uppercaseString) ||
                product.category!.uppercaseString.containsString(keyWord!.uppercaseString)) {
                self.products_.append(product)
            }
        }
        self.tableView.reloadData()
    }

    

}
