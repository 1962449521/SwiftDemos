//
//  NormalRestaurant.swift
//  Hungerer
//
//  Created by 胡 帅 on 15/5/23.
//  Copyright (c) 2015年 none. All rights reserved.
//

import Foundation
import JSONJoy

struct RestaurantStruct: JSONJoy {
     var id: String = ""
     var name: String = ""
     var city: String = ""
     var photoURL: String = ""
    
    init(_ decoder: JSONDecoder) {
        id = decoder["id"].string!
        name = decoder["name"].string!
        city = decoder["city"].string!
        photoURL = decoder["photoURL"].string!
    }

}
