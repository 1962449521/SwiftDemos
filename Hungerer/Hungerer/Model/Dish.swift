//
//  Dish.swift
//  
//
//  Created by 胡 帅 on 15/5/22.
//
//

import Foundation
import CoreData

class Dish: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var price: NSNumber
    @NSManaged var photoURL: String

}
