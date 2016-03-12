//
//  Restaurant.swift
//  
//
//  Created by 胡 帅 on 15/5/22.
//
//

import Foundation
import CoreData

class Restaurant: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var city: String
    @NSManaged var photoURL: String
    @NSManaged var dishes: NSSet

}
extension Restaurant {
    func addDishObject(value:Dish) {
        var items = self.mutableSetValueForKey("dishes");
        items.addObject(value)
    }
    
    func removeDishObject(value:Dish) {
        var items = self.mutableSetValueForKey("dishes");
        items.removeObject(value)
    }
}