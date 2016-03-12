//
//  CartMO.swift
//  Shopping
//
//  Created by 胡 帅 on 15/11/29.
//  Copyright © 2015年 Disney. All rights reserved.
//

import Foundation
import CoreData


public class CartMO: NSManagedObject {

    public func covert2NormalObject(normalObject:SPCart) {
        normalObject.name = self.name
        normalObject.price = self.price
        normalObject.image = self.image
        normalObject.uid = self.uid
        normalObject.count = self.count
    }
}
