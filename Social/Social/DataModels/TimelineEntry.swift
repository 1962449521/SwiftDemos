//
//  TimelineEntry.swift
//  Social
//
//  Created by  on 15/5/17.
//  Copyright (c) 2015年 griffith. All rights reserved.
//

import Foundation
import UIKit

final class TimelineEntry: BaseObject {
    // Properties
    var image:UIImage?
    var siteData:NSString?
    var text:NSString?
    
    // init
    override init() {
        super.init()
    }
    
    // NSCoding
    init(coder aDecoder: NSCoder)
    {
        super.init()
        self.image    = aDecoder.decodeObjectForKey("image") as? UIImage
        self.siteData = aDecoder.decodeObjectForKey("siteData") as? NSString
        self.text     = aDecoder.decodeObjectForKey("text") as? NSString
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.image, forKey: "image")
        aCoder.encodeObject(self.siteData, forKey: "siteData")
        aCoder.encodeObject(self.text, forKey: "text")
    }
    
}