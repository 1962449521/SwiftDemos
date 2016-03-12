//
//  NSPersistentStore+MagicalRecord.swift
//  MagicalRecord-Swift
//
//  Created by Jacky Wu on 10/6/15.
//  Copyright © 2015 Jacky Wu. All rights reserved.
//

import Foundation
import CoreData

public let kMagicalRecordDefaultStoreFileName: String = "CoreDataStore.sqlite"

public extension NSPersistentStore {
  static var defaultPersistentStore: NSPersistentStore? = nil
  
  public class func MR_defaultPersistentStore() -> NSPersistentStore? {
    return self.defaultPersistentStore
  }
  
  public class func MR_setDefaultPersistentStore(store: NSPersistentStore?) {
    self.defaultPersistentStore = store
  }
  
  public class func MR_directory(type: NSSearchPathDirectory) -> String? {
    return NSSearchPathForDirectoriesInDomains(type, NSSearchPathDomainMask.UserDomainMask, true).last
  }

  public class func MR_applicationDocumentsDirectory() -> String {
    return self.MR_directory(NSSearchPathDirectory.DocumentDirectory)!
  }

  public class func MR_applicationStorageDirectory() -> String {
    // assume BundleDisplayName and ApplicationSupportDirectory always exist
    let applicationName: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName") as! String
    let applicationSupportDirectory: NSString = self.MR_directory(NSSearchPathDirectory.ApplicationSupportDirectory)! as NSString
    return applicationSupportDirectory.stringByAppendingPathComponent(applicationName)
  }
  
  
  public class func MR_urlForStoreName(storeFileName: String) -> NSURL {
    let pathForStoreName: String = (self.MR_applicationStorageDirectory() as NSString).stringByAppendingPathComponent(storeFileName)
    return NSURL.fileURLWithPath(pathForStoreName)
  }

  public class func MR_cloudURLForUbiqutiousContainer(bucketName: String) -> NSURL? {
    let fileManager: NSFileManager = NSFileManager.init()
    var cloudURL: NSURL? = nil
    if fileManager.respondsToSelector("URLForUbiquityContainerIdentifier") {
      cloudURL = fileManager.URLForUbiquityContainerIdentifier(bucketName)
    }
    return cloudURL
  }

  public class func MR_defaultLocalStoreUrl() -> NSURL {
    return self.MR_urlForStoreName(kMagicalRecordDefaultStoreFileName)
  }
  
}
