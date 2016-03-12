//
//  SPProduct.swift
//  Shopping
//
//  Created by 胡 帅 on 15/11/28.
//  Copyright © 2015年 Disney. All rights reserved.
//

import Foundation

public class SPProduct: NSObject {
    var name:String?
    var price:String?
    var image:String?
    var description_:String?
    var category:String?
    var uid:String?
    var stock:String?
    
    public override init() {
        super.init()
    }
    
    public convenience init(fromDic: Dictionary<String, AnyObject>) {
        self.init()
        self.name = fromDic["name"] as? String
        self.price = fromDic["price"] as? String
        self.image = fromDic["image"] as? String
        self.description_ = fromDic["description"] as? String
        self.category = fromDic["category"] as? String
        self.uid = fromDic["uid"] as? String
        self.stock = fromDic["stock"] as? String
    }
    
    public func convert2ManagedObject(managedObject:ProductMO) {
        managedObject.name = self.name
        managedObject.price = self.price
        managedObject.image = self.image
        managedObject.description_ = self.description_
        managedObject.category = self.category
        managedObject.uid = self.uid
        managedObject.stock = self.stock
    }
    /*
 {"name": "Flashforge Finder 3D Printer", "price": "995.00", "image": "http://partiklezoo.com/products/u0001.jpg", "description": "The Finder 3D is an excellent first printer, reliable and with high quality. With a non-heated print area of 14x14x14cm, it can print with PLA to a high standard.", "category": "3D Printers", "uid": "u0001", "stock": "5" }
*/
}
