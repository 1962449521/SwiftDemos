//
//  Profile.swift
//  
//
//  Created by 胡 帅 on 15/5/22.
//
//

import Foundation
import CoreData

class Profile: NSManagedObject {

    @NSManaged var address: String
    @NSManaged var phoneNum: String
    @NSManaged var orders: NSMutableSet

}
