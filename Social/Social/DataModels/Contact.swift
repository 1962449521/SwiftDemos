//
//  Contact.swift
//  Social
//
//  Created by  on 15/5/17.
//  Copyright (c) 2015年 griffith. All rights reserved.
//

import Foundation
import UIKit

final class Contact: BaseObject,NSCoding {
    // Properties
    var address:NSString?
    var firstName:NSString?
    var image:UIImage?
    var imageURL:NSString?
    var lastName:NSString?
    
    // Relationships
    var sites:[SocialMediaAccount]?
    
    // init
    override init() {
        super.init()
        self.firstName = "firstName"
        self.lastName  = "lastName"
        self.address   = "address"
        self.image     = UIImage(named: "defaultAvatar")
        self.imageURL  = "imageURL"
        var sma1:SocialMediaAccount = SocialMediaAccount()
        var sma2:SocialMediaAccount = SocialMediaAccount()
        var sma3:SocialMediaAccount = SocialMediaAccount()
        sma1.type = 1
        sma2.type = 2
        sma3.type = 3
        self.sites = [sma1, sma2, sma3]

    }
    
    // NSCoding
    init(coder aDecoder: NSCoder)
    {
        super.init()
        self.address   = aDecoder.decodeObjectForKey("address") as? String
        self.firstName = aDecoder.decodeObjectForKey("firstName") as? String
        var imageData:NSData? = aDecoder.decodeObjectForKey("image") as? NSData
        if(imageData != nil){
            self.image     = UIImage(data: imageData!, scale: 1.0)
        }
        self.imageURL  = aDecoder.decodeObjectForKey("imageURL") as? String
        self.lastName  = aDecoder.decodeObjectForKey("lastName") as? String
        self.sites     = aDecoder.decodeObjectForKey("sites") as? [SocialMediaAccount]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.address, forKey: "address")
        aCoder.encodeObject(self.firstName, forKey: "firstName")
        var imageData:NSData = UIImageJPEGRepresentation(self.image, 1.0)
        aCoder.encodeObject(imageData, forKey: "image")
        aCoder.encodeObject(self.imageURL, forKey: "imageURL")
        aCoder.encodeObject(self.lastName, forKey: "lastName")
        aCoder.encodeObject(self.sites, forKey: "sites")
    }
    
    
}