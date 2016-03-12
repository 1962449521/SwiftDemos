//
//  MagicalRecordInternal.swift
//  MagicalRecord-Swift
//
//  Created by Jacky Wu on 10/6/15.
//  Copyright © 2015 Jacky Wu. All rights reserved.
//

import Foundation
import CoreData

//#if NS_BLOCKS_AVAILABLE
//  extern NSString * const kMagicalRecordCleanedUpNotification;
//  @class NSManagedObjectContext;
//  typedef void (^CoreDataBlock)(NSManagedObjectContext *context);
//#endif

public enum MagicalRecordVersionTag: UInt {
  case MagicalRecordVersionTag2_2 = 220
  case MagicalRecordVersionTag2_3 = 230
  case MagicalRecordVersionTag3_0 = 300
}

public class MagicalRecord {
  
  
  /*

+ (void) initialize;
{
if (self == [MagicalRecord class])
{
[self setShouldAutoCreateManagedObjectModel:YES];
[self setShouldAutoCreateDefaultPersistentStoreCoordinator:NO];
#ifdef DEBUG
[self setShouldDeleteStoreOnModelMismatch:YES];
#else
[self setShouldDeleteStoreOnModelMismatch:NO];
#endif
}
}
  */

  public class func version() -> MagicalRecordVersionTag {
    return MagicalRecordVersionTag.MagicalRecordVersionTag2_2
  }
  
  public class func cleanUp() {
    cleanErrorHandling()
    cleanUpStack()
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.postNotificationName(kMagicalRecordCleanedUpNotification, object: nil, userInfo: nil)
  }
  
  private class func cleanUpStack() {
    NSManagedObjectContext.MR_cleanUP()
    NSManagedObjectModel.MR_setDefaultManagedObjectModel(nil)
    NSPersistentStoreCoordinator.MR_setDefaultStoreCoordinator(nil)
    NSPersistentStore.MR_setDefaultPersistentStore(nil)
  }
  
  /*
  private class func cleanErrorHandling() {
    
  }
  
  private class func MR_cleanUP() {
    
  }
  */

  public class func currentStack() -> String {
    var status = "Current Default Core Data Stack: ----\n"
    status.appendContentsOf("Model: \(NSManagedObjectModel.MR_defaultManagedObjectModel().entityVersionHashesByName()))")
    status.appendContentsOf("Coordinator: \(NSPersistentStoreCoordinator.MR_defaultStoreCoordinator())")
    status.appendContentsOf("Store: \(NSPersistentStore.MR_defaultPersistentStore())")
    status.appendContentsOf("Default Context: \(NSManagedObjectContext.MR_defaultContext()?.MR_description())")
    status.appendContentsOf("Context Chain: \(NSManagedObjectContext.MR_defaultContext()?.MR_parentChain())\n")
    return status
  }
  
  public class func setDefaultModelNamed(modelName: String) {
    if let model = NSManagedObjectModel.MR_managedObjectModelNamed(modelName) {
       NSManagedObjectModel.MR_setDefaultManagedObjectModel(model)
    }
  }

  public class func setDefaultModelFromClass(modelClass: AnyClass) {
    let bundle = NSBundle(forClass: modelClass)
    if let model = NSManagedObjectModel.mergedModelFromBundles([bundle]) {
      NSManagedObjectModel.MR_setDefaultManagedObjectModel(model)
    }
  }
  
  public class func defaultStoreName() -> String {
    var defaultName: String? = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleNameKey as String) as? String
    if (defaultName == nil) {
      defaultName = kMagicalRecordDefaultStoreFileName
    }
    if var defaultName = defaultName where defaultName.hasSuffix("sqlite") {
      defaultName = (defaultName as NSString).stringByAppendingPathComponent("sqlite")
    }
    return defaultName!
  }
}





