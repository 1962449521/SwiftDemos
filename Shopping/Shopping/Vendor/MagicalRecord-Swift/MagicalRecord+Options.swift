//
//  MagicalRecord+Options.swift
//  MagicalRecord-Swift
//
//  Created by Jacky Wu on 10/6/15.
//  Copyright © 2015 Jacky Wu. All rights reserved.
//

import Foundation
import CoreData

public enum MagicalRecordLoggingMask: UInt {
  case MagicalRecordLoggingMaskError = 0b00001
  /** Log warnings, and all errors */
  case MagicalRecordLoggingMaskWarn = 0b00010
  /** Log informative messagess, warnings and all errors */
  case MagicalRecordLoggingMaskInfo = 0b00100
  /** Log debugging messages, informative messages, warnings and all errors */
  case MagicalRecordLoggingMaskDebug = 0b01000
  /** Log verbose diagnostic information, debugging messages, informative messages, messages, warnings and all errors */
  case MagicalRecordLoggingMaskVerbose = 0b10000
}

public enum MagicalRecordLoggingLevel: UInt {
  /** Don't log anything */
//  case MagicalRecordLoggingLevelOff = 0
  /** Log all errors and fatal messages */
//  case MagicalRecordLoggingLevelError =
  /** Log warnings, errors and fatal messages */
//  case MagicalRecordLoggingLevelWarn = (MagicalRecordLoggingLevelError | MagicalRecordLoggingMaskWarn)
  /** Log informative, warning and error messages */
//  case MagicalRecordLoggingLevelInfo = (MagicalRecordLoggingLevelWarn | MagicalRecordLoggingMaskInfo)
  /** Log all debugging, informative, warning and error messages */
//  case MagicalRecordLoggingLevelDebug = (MagicalRecordLoggingLevelInfo | MagicalRecordLoggingMaskDebug)
  /** Log verbose diagnostic, debugging, informative, warning and error messages */
//  case MagicalRecordLoggingLevelVerbose = (MagicalRecordLoggingLevelDebug | MagicalRecordLoggingMaskVerbose)
  /** Log everything */
  case MagicalRecordLoggingLevelAll = 1
}

//MARK: MagicalRecord+Options
public extension MagicalRecord {
  static var shouldAutoCreateManagedObjectModel: Bool = false
  static var shouldAutoCreateDefaultPersistentStoreCoordinator: Bool = false
  static var shouldDeleteStoreOnModelMismatch: Bool = false
  
  #if DEBUG
  static var loggingLevel: MagicalRecordLoggingLevel = MagicalRecordLoggingLevelDebug
  #else
  static var loggingLevel: MagicalRecordLoggingLevel = MagicalRecordLoggingMaskError
  #endif
}






 