//
//  CartMO+CoreDataProperties.swift
//  Shopping
//
//  Created by 胡 帅 on 15/11/29.
//  Copyright © 2015年 Disney. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CartMO {

    @NSManaged var uid: String?
    @NSManaged var image: String?
    @NSManaged var name: String?
    @NSManaged var price: String?
    @NSManaged var count: NSNumber?

}
