//
//  SPCart.swift
//  Shopping
//
//  Created by 胡 帅 on 15/11/29.
//  Copyright © 2015年 Disney. All rights reserved.
//

import UIKit

public class SPCart: NSObject {
    var name:String?
    var price:String?
    var image:String?
    var count: NSNumber?
    var uid:String?
    
    public override init() {
        super.init()
    }
    
    public func convert2ManagedObject(managedObject:CartMO) {
        managedObject.name = self.name
        managedObject.price = self.price
        managedObject.image = self.image
        managedObject.uid = self.uid
        managedObject.count = self.count
    }
    /*
    uid: String?
    @NSManaged var image: String?
    @NSManaged var name: String?
    @NSManaged var price: String?
    @NSManaged var count: NSNumber?

*/
}
