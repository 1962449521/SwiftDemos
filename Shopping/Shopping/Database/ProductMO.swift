//
//  ProductMO.swift
//  Shopping
//
//  Created by 胡 帅 on 15/11/28.
//  Copyright © 2015年 Disney. All rights reserved.
//

import Foundation
import CoreData

@objc(ProductMO)
public class ProductMO: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    public func covert2NormalObject(normalObject:SPProduct) {
        normalObject.name = self.name
        normalObject.price = self.price
        normalObject.image = self.image
        normalObject.description_ = self.description_
        normalObject.category = self.category
        normalObject.uid = self.uid
        normalObject.stock = self.stock
    }
    
}
