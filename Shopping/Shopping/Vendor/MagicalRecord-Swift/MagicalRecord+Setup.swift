//
//  MagicalRecord+Setup.swift
//  MagicalRecord-Swift
//
//  Created by Jacky Wu on 10/6/15.
//  Copyright © 2015 Jacky Wu. All rights reserved.
//

import Foundation
import CoreData

//MARK: MagicalRecord+Setup
public extension MagicalRecord {
  
  public class func setupCoreDataStack() {
    setupCoreDataStackWithStoreNamed(defaultStoreName())
  }
  
  public class func setupAutoMigratingCoreDataStack() {
    setupCoreDataStackWithAutoMigratingSqliteStoreNamed(defaultStoreName())
  }

  public class func setupCoreDataStackWithStoreNamed(storeName: String) {
    if (NSPersistentStoreCoordinator.MR_defaultStoreCoordinator() == nil) {
        let coordinator = NSPersistentStoreCoordinator.MR_coordinatorWithSqliteStoreNamed(storeName)
        NSPersistentStoreCoordinator.MR_setDefaultStoreCoordinator(coordinator)
        NSManagedObjectContext.MR_initializeDefaultContextWithCoordinator(coordinator)
    }
  }

  public class func setupCoreDataStackWithAutoMigratingSqliteStoreNamed(storeName: String) {
    if (NSPersistentStoreCoordinator.MR_defaultCoordinator() == nil) {
      let coordinator = NSPersistentStoreCoordinator.MR_coordinatorWithAutoMigratingSqliteStoreNamed(storeName)
      NSPersistentStoreCoordinator.MR_setDefaultStoreCoordinator(coordinator)
      NSManagedObjectContext.MR_initializeDefaultContextWithCoordinator(coordinator)
    }
  }
  
  public class func setupCoreDataStackWithStoreAtURL(storeURL: NSURL) {
    if (NSPersistentStoreCoordinator.MR_defaultCoordinator() == nil) {
      let coordinator = NSPersistentStoreCoordinator.MR_coordinatorWithSqliteStoreAtURL(storeURL)
      NSPersistentStoreCoordinator.MR_setDefaultStoreCoordinator(coordinator)
      NSManagedObjectContext.MR_initializeDefaultContextWithCoordinator(coordinator)
    }
  }
  
  public class func setupCoreDataStackWithAutoMigratingSqliteStoreAtURL(storeURL: NSURL) {
    if (NSPersistentStoreCoordinator.MR_defaultCoordinator() == nil) {
      let coordinator = NSPersistentStoreCoordinator.MR_coordinatorWithAutoMigratingSqliteStoreAtURL(storeURL)
      NSPersistentStoreCoordinator.MR_setDefaultStoreCoordinator(coordinator)
      NSManagedObjectContext.MR_initializeDefaultContextWithCoordinator(coordinator)
    }
  }

  public class func setupCoreDataStackWithInMemoryStore() {
    if (NSPersistentStoreCoordinator.MR_defaultCoordinator() == nil) {
      let coordinator = NSPersistentStoreCoordinator.MR_coordinatorWithInMemoryStore()
      NSPersistentStoreCoordinator.MR_setDefaultStoreCoordinator(coordinator)
      NSManagedObjectContext.MR_initializeDefaultContextWithCoordinator(coordinator)
    }
  }
}
