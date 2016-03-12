//
//  SocialMediaAccount.swift
//  Social
//
//  Created by on 15/5/17.
//  Copyright (c) 2015年 griffith. All rights reserved.
//

import Foundation

final class SocialMediaAccount: BaseObject,NSCoding {
    // Properties
    var identifier:NSString? = ""
    var type:Int = 0
    
    // Relationships
    var entries:[TimelineEntry]?
    
    // init
    override init() {
        super.init()
    }
    
    // NSCoding
    init(coder aDecoder: NSCoder)
    {
        super.init()
        self.identifier = aDecoder.decodeObjectForKey("identifier") as? String
        self.type       = aDecoder.decodeIntegerForKey("type")
        self.entries    = aDecoder.decodeObjectForKey("entries") as? [TimelineEntry]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.identifier, forKey: "identifier")
        aCoder.encodeInteger(self.type, forKey: "type")
        aCoder.encodeObject(self.entries, forKey: "entries")
    }

    
}