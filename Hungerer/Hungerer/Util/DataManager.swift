//
//  DataManager.swift
//  Hungerer
//
//  Created by 胡 帅 on 15/5/21.
//  Copyright (c) 2015年 none. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum SortType:Int32{
    case NoAccending
    case Ascending
    case Descending
}

class DataManager: NSObject {
    
    static func loadData(predicate:NSPredicate?, entityName:String , sortType:[NSSortDescriptor]?)->[AnyObject]?{
        var app = UIApplication.sharedApplication().delegate as! AppDelegate
        var context = app.managedObjectContext
        var model:NSManagedObjectModel = app.managedObjectModel

        var request = NSFetchRequest()

        var allEntities = model.entitiesByName
        var searchEntityDescription = allEntities[entityName] as! NSEntityDescription

        request.entity = searchEntityDescription

        if let aSortType = sortType{
            request.sortDescriptors = aSortType
        }

        
        if let aPredicate = predicate{
            request.predicate = predicate
        }
        return context?.executeFetchRequest(request, error: nil)
    }
    
    static func saveContext(){
        var app = UIApplication.sharedApplication().delegate as! AppDelegate
        app.saveContext()
    }
    
    static func toBeInsertEnitity(entityName:String) -> AnyObject?{
        var app = UIApplication.sharedApplication().delegate as! AppDelegate
        var context = app.managedObjectContext
        return NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: context!)
    }
    
   

    
}