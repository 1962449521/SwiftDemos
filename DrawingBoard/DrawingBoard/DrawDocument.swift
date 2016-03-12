//
//  DrawDocument.swift
//  DrawingBoard
//
//  Created by TomCat on 15-10-10.
//  Copyright (c) 2015年 Disney. All rights reserved.
//

import UIKit

class DrawDocument: UIDocument {
    var drawSource:NSMutableArray?
    
    override func loadFromContents(contents: AnyObject, ofType typeName: String?) throws {
            self.drawSource = NSKeyedUnarchiver.unarchiveObjectWithData(contents as! NSData) as? NSMutableArray
    }
    
    override func contentsForType(typeName: String) throws -> AnyObject {
        return NSKeyedArchiver.archivedDataWithRootObject(self.drawSource!)
    }
 
}
