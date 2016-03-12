//
//  NSPersistentStoreCoordinator+MagicalRecord.swift
//  MagicalRecord-Swift
//
//  Created by Jacky Wu on 10/6/15.
//  Copyright © 2015 Jacky Wu. All rights reserved.
//

import Foundation
import CoreData

let kMagicalRecordPSCDidCompleteiCloudSetupNotification = "kMagicalRecordPSCDidCompleteiCloudSetupNotification"
let kMagicalRecordPSCMismatchWillDeleteStore = "kMagicalRecordPSCMismatchWillDeleteStore"
let kMagicalRecordPSCMismatchDidDeleteStore = "kMagicalRecordPSCMismatchDidDeleteStore"
let kMagicalRecordPSCMismatchWillRecreateStore = "kMagicalRecordPSCMismatchWillRecreateStore"
let kMagicalRecordPSCMismatchDidRecreateStore = "kMagicalRecordPSCMismatchDidRecreateStore"
let kMagicalRecordPSCMismatchCouldNotDeleteStore = "kMagicalRecordPSCMismatchCouldNotDeleteStore"
let kMagicalRecordPSCMismatchCouldNotRecreateStore = "kMagicalRecordPSCMismatchCouldNotRecreateStore"

//MARK: NSPersistentStoreCoordinator+MagicalRecord
public extension NSPersistentStoreCoordinator {
  
  public class func MR_defaultStoreCoordinator() -> NSPersistentStoreCoordinator {
    
  }
  
  public class func MR_setDefaultStoreCoordinator(coordinator: NSPersistentStoreCoordinator) {
    
  }
  
  public class func MR_coordinatorWithInMemoryStore() -> NSPersistentStoreCoordinator {
    
  }
  
  public class func MR_newPersistentStoreCoordinator() -> NSPersistentStoreCoordinator {
    
  }
  
  public class func MR_coordinatorWithSqliteStoreNamed(storeFileName: String) -> NSPersistentStoreCoordinator {
    
  }
  
  public class func MR_coordinatorWithAutoMigratingSqliteStoreNamed(storeFileName: String) -> NSPersistentStoreCoordinator {
    
  }

  public class func MR_coordinatorWithSqliteStoreAtURL(storeURL: NSURL) -> NSPersistentStoreCoordinator {
    
  }
  
  public class func MR_coordinatorWithAutoMigratingSqliteStoreAtURL(storeURL: NSURL) -> NSPersistentStoreCoordinator {
    
  }
  
  public class func MR_coordinatorWithPersistentStore(persistentStore: NSPersistentStore) -> NSPersistentStoreCoordinator {
    
  }

  public class func MR_coordinatorWithiCloudContainerID(containerID: String, contentNameKey: String, localStoreNamed localStoreName: String, cloudStorePathComponent subPathComponent: String) {
    
  }

  public class func MR_coordinatorWithiCloudContainerID(containerID: String, contentNameKey: String, localStoreAtURL storeURL: NSURL, cloudStorePathComponent subPathComponent: String) {
    
  }
  
  public class func MR_coordinatorWithiCloudContainerID(containerID: String, contentNameKey: String, localStoreNamed localStoreName: String, cloudStorePathComponent subPathComponent: String, completion completionHandler: () -> Void) {
    
  }
  
  public class func MR_coordinatorWithiCloudContainerID(containerID: String, contentNameKey: String, localStoreAtURL storeURL: NSURL, cloudStorePathComponent subPathComponent: String, completion completionHandler: () -> Void) {
    
  }
  
  public class func MR_addInMemoryStore() -> NSPersistentStore {
    
  }
  
  public class func MR_addAutoMigratingSqliteStoreNamed(storeFileName: String) -> NSPersistentStore {
    
  }
  
  public class func MR_addAutoMigratingSqliteStoreAtURL(storeURL: NSURL) -> NSPersistentStore {
    
  }
  
  // need to check __autoreleasing and dictionary type
  public class func MR_addSqliteStoreNamed(storeFileName: AnyObject, withOptions options: [String: AnyObject]) -> NSPersistentStore {
    
  }
  
  public class func MR_addSqliteStoreNamed(storeFileName: AnyObject, configuration: String, withOptions options: [String: AnyObject]) -> NSPersistentStore {
    
  }
  
  public class func MR_addiCloudContainerID(containerID: String, contentNameKey: String, localStoreNamed localStoreName: String, cloudStorePathComponent subPathComponent: String) {
    
  }
  
  public class func MR_addiCloudContainerID(containerID: String, contentNameKey: String, localStoreAtURL storeURL: NSURL, cloudStorePathComponent subPathComponent: String) {
    
  }
  
  public class func MR_addiCloudContainerID(containerID: String, contentNameKey: String, localStoreNamed localStoreName: String, cloudStorePathComponent subPathComponent: String, completion completionHandler: () -> Void) {
    
  }
  
  public class func MR_addiCloudContainerID(containerID: String, contentNameKey: String, localStoreAtURL storeURL: NSURL, cloudStorePathComponent subPathComponent: String, completion completionHandler: () -> Void) {
    
  }
}

