//
//  NSManagedObjectModel+MagicalRecord.swift
//  MagicalRecord-Swift
//
//  Created by Jacky Wu on 10/6/15.
//  Copyright © 2015 Jacky Wu. All rights reserved.
//

import CoreData

public extension NSManagedObjectModel {
  
  static var defaultManagedObjectModel_: NSManagedObjectModel?
  
  class func MR_defaultManagedObjectModel() -> NSManagedObjectModel? {
    if self.defaultManagedObjectModel_ == nil && MagicalRecord.shouldAutoCreateManagedObjectModel() {
      self.MR_setDefaultManagedObjectModel(self.MR_mergedObjectModelFromMainBundle())
    }
    return self.defaultManagedObjectModel_
  }
  
  class func MR_setDefaultManagedObjectModel(newDefaultModel: NSManagedObjectModel?) {
    self.defaultManagedObjectModel_ = newDefaultModel
  }
  
  class func MR_mergedObjectModelFromMainBundle() -> NSManagedObjectModel? {
    return self.mergedModelFromBundles(nil)
  }

  class func MR_newModelNamed(modelName: String, inBundleName bundleName: String) -> NSManagedObjectModel? {
    let rscName: String = (modelName as NSString).stringByDeletingPathExtension
    let type: String = (modelName as NSString).pathExtension

    if let path = NSBundle.mainBundle().pathForResource(rscName, ofType: type, inDirectory: bundleName) {
      let modelUrl: NSURL = NSURL.fileURLWithPath(path, isDirectory: false)
      return NSManagedObjectModel.init(contentsOfURL: modelUrl)
    }
    return nil
  }
  
  class func MR_newModelNamed(modelName: String, inBundle bundle: NSBundle) -> NSManagedObjectModel? {
    let rscName: String = (modelName as NSString).stringByDeletingPathExtension
    let type : String = (modelName as NSString).pathExtension
    if let path = bundle.pathForResource(rscName, ofType: type) {
      let momURL: NSURL = NSURL.fileURLWithPath(path)
      return NSManagedObjectModel.init(contentsOfURL: momURL)
    }
    return nil
  }
  
  class func MR_newManagedObjectModelNamed(modelFileName: String) -> NSManagedObjectModel? {
    let rscName: String = (modelFileName as NSString).stringByDeletingPathExtension
    let type: String = (modelFileName as NSString).pathExtension
    if let path = NSBundle.mainBundle().pathForResource(rscName, ofType: type) {
      let momURL: NSURL = NSURL.fileURLWithPath(path)
      return NSManagedObjectModel.init(contentsOfURL: momURL)
    }
    return nil
  }

  class func MR_managedObjectModelNamed(modelFileName: String) -> NSManagedObjectModel? {
    return self.MR_newManagedObjectModelNamed(modelFileName)
  }
  
}
