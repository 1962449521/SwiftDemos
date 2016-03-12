//
//  MockData.swift
//  Social
//
//  Created by   on 15/5/18.
//  Copyright (c) 2015年 griffith. All rights reserved.
//

import Foundation
import UIKit

func mockData()->[Contact]?{
    var timelineEntry1   = TimelineEntry()
    timelineEntry1.image = UIImage(named: "photo1");
    timelineEntry1.text  = "this is timelineEntry1"
    
    var timelineEntry2   = TimelineEntry()
    timelineEntry2.image = UIImage(named: "photo2");
    timelineEntry2.text  = "this is timelineEntry2"
    
    var timelineEntry3   = TimelineEntry()
    timelineEntry3.image = UIImage(named: "photo3");
    timelineEntry3.text  = "this is timelineEntry3"
    
    var timelineEntry4   = TimelineEntry()
    timelineEntry4.image = UIImage(named: "photo4");
    timelineEntry4.text  = "this is timelineEntry4"
    
    var timelineEntry5   = TimelineEntry()
    timelineEntry5.image = UIImage(named: "photo5");
    timelineEntry5.text  = "this is timelineEntry5"
    
    var timelineEntry6   = TimelineEntry()
    timelineEntry6.image = UIImage(named: "photo6");
    timelineEntry6.text  = "this is timelineEntry6"
    
    var socialMediaAccount1        = SocialMediaAccount()
    socialMediaAccount1.identifier = "Weibo"
    socialMediaAccount1.type       = 0
    socialMediaAccount1.entries    = [timelineEntry1, timelineEntry2]
    
    var socialMediaAccount2        = SocialMediaAccount()
    socialMediaAccount2.identifier = "Facebook"
    socialMediaAccount2.type       = 1
    socialMediaAccount2.entries    = [timelineEntry3]
    
    var socialMediaAccount3        = SocialMediaAccount()
    socialMediaAccount3.identifier = "Weibo"
    socialMediaAccount3.type       = 0
    socialMediaAccount3.entries    = [timelineEntry4, timelineEntry5]
    
    var socialMediaAccount4        = SocialMediaAccount()
    socialMediaAccount4.identifier = "Facebook"
    socialMediaAccount4.type       = 1
    socialMediaAccount4.entries    = [timelineEntry6]
    
    var  contact1      = Contact()
    contact1.address   = "address of contact1"
    contact1.image     = UIImage(named: "avatar1")
    contact1.imageURL  = ""
    contact1.firstName = "John"
    contact1.lastName  = "Black"
    
    var  contact2      = Contact()
    contact2.address   = "address of contact2"
    contact2.image     = UIImage(named: "avatar2")
    contact2.imageURL  = ""
    contact2.firstName = "Eve"
    contact2.lastName  = "White"
    
    return [contact1, contact2]
}

