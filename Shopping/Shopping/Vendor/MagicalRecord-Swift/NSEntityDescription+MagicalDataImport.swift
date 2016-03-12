//
//  NSEntityDescription+MagicalDataImport.swift
//  MagicalRecord-Swift
//
//  Created by Jacky Wu on 10/6/15.
//  Copyright © 2015 Jacky Wu. All rights reserved.
//

import Foundation
import CoreData

//MARK: NSEntityDescription+MagicalRecordDataImport
public extension NSEntityDescription {
  
  public func MR_primaryAttributeToRelateBy() -> NSAttributeDescription {
    
  }
  
  public func MR_createInstanceInContext(context: NSManagedObjectContext) -> NSManagedObjectContext {
    
  }
  
  /**
  *	Safely returns an attribute description for the given name, otherwise returns nil. In certain circumstances, the keys of the dictionary returned by `attributesByName` are not standard NSStrings and won't match using object subscripting or standard `objectForKey:` lookups.
  *
  *  There may be performance implications to using this method if your entity has hundreds or thousands of attributes.
  *
  *	@param	name	Name of the attribute description in the `attributesByName` dictionary on this instance
  *
  *	@return	The attribute description for the given name, otherwise nil
  */
  public func MR_attributeDescriptionForName(name: String) -> NSAttributeDescription {
    
  }
}
