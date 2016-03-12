//
//  Order.swift
//  
//
//  Created by 胡 帅 on 15/5/22.
//
//

import Foundation
import CoreData

class Order: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var id: String
    @NSManaged var isSubmitted: NSNumber
    @NSManaged var total: String
    @NSManaged var dishes: NSMutableSet
    @NSManaged var owner: Profile

}
