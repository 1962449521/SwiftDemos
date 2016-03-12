//
//  MagicalRecord+Actions.swift
//  MagicalRecord-Swift
//
//  Created by Jacky Wu on 10/6/15.
//  Copyright © 2015 Jacky Wu. All rights reserved.
//

import Foundation
import CoreData

//MARK: MagicalRecord+Actions
public extension MagicalRecord {
  
  public func saveWithBlock(block: ((localContext: NSManagedObjectContext) -> Void)? ) {
    self.saveWithBlock(block, completion: nil)
  }
  
  public func saveWithBlock(block: ((localContext: NSManagedObjectContext) -> Void)?, completion: (MRSaveCompletionHandler)?) {
    
    let savingContext: NSManagedObjectContext? = NSManagedObjectContext.MR_rootSavingContext()
    let localContext: NSManagedObjectContext? = NSManagedObjectContext.MR_contextWithParent(savingContext)
    
    if let localContext = localContext {
      localContext.performBlock({ () -> Void in
        localContext.MR_setWorkingName(NSStringFromSelector(_cmd))
        if let block = block {
          block(localContext: localContext)
        }
        localContext.MR_saveWithOptions(NRSaveParentContexts completion:completion)
      })
    }
  }

  public func saveWithBlockAndWait(block: ((localContext: NSManagedObjectContext) -> Void)?) {
    let savingContext: NSManagedObjectContext? = NSManagedObjectContext.MR_rootSavingContext()
    let localContext: NSManagedObjectContext? = NSManagedObjectContext.MR_contextWithParent(savingContext)
    
    if let localContext = localContext {
      localContext.MR_setWorkingName(NSStringFromSelector(_cmd))
      if let block = block {
        block(localContext: localContext)
      }
      localContext.MR_saveWithOptions(NRSaveParentContexts completion:nil)
    }
  }
}