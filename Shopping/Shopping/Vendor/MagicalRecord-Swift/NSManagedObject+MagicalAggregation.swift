//
//  NSManagedObject+MagicalAggregation.swift
//  MagicalRecord-Swift
//
//  Created by Jacky Wu on 10/6/15.
//  Copyright © 2015 Jacky Wu. All rights reserved.
//

import Foundation
import CoreData

//MARK: NSManagedObject+MagicalAggregation
public extension NSManagedObject {
  
  public class func MR_numberOfEntities() -> NSNumber {
    
  }
  
  public class func MR_numberOfEntitiesWithContext(context: NSManagedObjectContext) -> NSNumber {
    
  }
  
  public class func MR_numberOfEntitiesWithPredicate(searchTerm: NSPredicate) -> NSNumber {
    
  }
  
  public class func MR_numberEntitiesWithPredicate(searchTerm: NSPredicate, inContext context: NSManagedObjectContext) -> NSNumber {
    
  }
  
  public class func MR_countOfEntities() -> UInt {
    
  }
  
  public class func MR_countOfEntitiesWithContext(context: NSManagedObjectContext) -> UInt {
    
  }
  
  public class func MR_countOfEntitiesWithPredicate(searchFilter: NSPredicate) -> UInt {
    
  }
  
  public class func MR_countOfEntitiesWithPredicate(searchFilter: NSPredicate, inContext context: NSManagedObjectContext) -> UInt {
    
  }
  
  public class func MR_hasAtLestOneEntity() -> Bool {
    
  }
  
  public class func MR_hasAtLeastOneEntityInContext(context: NSManagedObjectContext) -> Bool {
    
  }
  
  public func MR_minValueFor(property: String) -> AnyObject {
    
  }
  
  public func MR_maxValueFor(property: String) -> AnyObject {
    
  }
  
  public class func MR_aggregateOperation(function: String, onAttribute attributeName: String, withPredicate predicate: NSPredicate, inContext context: NSManagedObjectContext) -> AnyObject {
    
  }
  
  public class func MR_aggregateOperation(function: String, onAttribute attributeName: String, withPredicate predicate: NSPredicate) -> AnyObject {
    
  }
  
  /**
  *  Supports aggregating values using a key-value collection operator that can be grouped by an attribute.
  *  See https://developer.apple.com/library/ios/documentation/cocoa/conceptual/KeyValueCoding/Articles/CollectionOperators.html for a list of valid collection operators.
  *
  *  @since 2.3.0
  *
  *  @param collectionOperator   Collection operator
  *  @param attributeName        Entity attribute to apply the collection operator to
  *  @param predicate            Predicate to filter results
  *  @param groupingKeyPath      Key path to group results by
  *  @param context              Context to perform the request in
  *
  *  @return Results of the collection operator, filtered by the provided predicate and grouped by the provided key path
  */
  
  public class func MR_aggregateOperation(collectionOperator: String, onAttribute attribuateName: String, withPredicate predicate: NSPredicate, groupBy groupingKeyPath: String, inContext context:NSManagedObjectContext) {
    
  }
  
  /**
  *  Supports aggregating values using a key-value collection operator that can be grouped by an attribute.
  *  See https://developer.apple.com/library/ios/documentation/cocoa/conceptual/KeyValueCoding/Articles/CollectionOperators.html for a list of valid collection operators.
  *
  *  This method is run against the default MagicalRecordStack's context.
  *
  *  @since 2.3.0
  *
  *  @param collectionOperator   Collection operator
  *  @param attributeName        Entity attribute to apply the collection operator to
  *  @param predicate            Predicate to filter results
  *  @param groupingKeyPath      Key path to group results by
  *
  *  @return Results of the collection operator, filtered by the provided predicate and grouped by the provided key path
  */
  public class func MR_aggregateOperation(collectionOperator: String, onAttribuate attributeName: String, withPredicate predicate: NSPredicate, groupBy groupingKeyPath: String) {
    
  }
  
  public func MR_objectWithMinValueFor(property: String) -> self {
    
  }
  
  public func MR_objectWithMinValueFor(property: String, inContext context: NSManagedObjectContext) -> self {
    
  }
}
