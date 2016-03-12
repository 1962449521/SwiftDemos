//
//  GalleryCollectionViewController.swift
//  DrawingBoard
//
//  Created by TomCat on 15-10-10.
//  Copyright (c) 2015年 Disney. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GalleryCollectionViewCell"

class GalleryCollectionViewController: UICollectionViewController {

    var dataSource:NSMutableArray?
    private var selectedIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "iCloud", style:UIBarButtonItemStyle.Plain , target: self, action: "switchSource")
        dataSource = APPDataSource_Local

    }
    func switchSource(){
        if (self.navigationItem.rightBarButtonItem?.title == "Local") {
            self.navigationItem.rightBarButtonItem?.title = "iCloud"
            dataSource = APPDataSource_Local

        } else {
            self.navigationItem.rightBarButtonItem?.title = "Local"
            dataSource = APPDataSource_iCloud!.drawSource

        }
        self.collectionView!.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataSource!.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:GalleryCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GalleryCollectionViewCell
        
        cell.imageView.image = (self.dataSource![indexPath.row] as! DrawModel).image
        cell.commentLabel.text =  (self.dataSource![indexPath.row] as! DrawModel).comment
        return cell
    }

    // MARK: UICollectionViewDelegate
    override  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        selectedIndex = indexPath.row
        self.performSegueWithIdentifier("showDetail", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination:DetailViewController = segue.destinationViewController as! DetailViewController
        destination.dataModel = self.dataSource![selectedIndex!] as? DrawModel
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
