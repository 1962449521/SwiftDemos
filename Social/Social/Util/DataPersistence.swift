//
//  DataPersistence.swift
//  Social
//
//  Created by   on 15/5/17.
//  Copyright (c) 2015年 griffith. All rights reserved.
//

import Foundation
import UIKit

let dataPersistencePath     = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! NSString
let dataPersistenceFilePath = dataPersistencePath.stringByAppendingPathComponent("data.archive")


class DataPersistence {
    // Methods
    func save(){
        var data     = NSMutableData()
        var archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(contacts, forKey: "contacts")
        archiver.finishEncoding()
        data.writeToFile(dataPersistenceFilePath, atomically: true)
    }
    func load() -> [Contact]?{
        var unarchiveData = NSData(contentsOfFile: dataPersistenceFilePath)
        if((unarchiveData) != nil){
            var unarchiver     = NSKeyedUnarchiver(forReadingWithData: unarchiveData!)
            var loadedContacts = unarchiver.decodeObjectForKey("contacts") as? [Contact]
            unarchiver.finishDecoding()
            return loadedContacts
        }
        else{
            return nil;
        }
    }
}