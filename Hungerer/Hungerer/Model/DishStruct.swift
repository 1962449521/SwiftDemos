//
//  DishStruct.swift
//  Hungerer
//
//  Created by 胡 帅 on 15/5/23.
//  Copyright (c) 2015年 none. All rights reserved.
//

import UIKit

import Foundation
import JSONJoy

struct DishStruct: JSONJoy {
    var id: String?
    var name: String?
    var price: Float?
    var photoURL: String?
    
    init(_ decoder: JSONDecoder) {
        id = decoder["id"].string
        name = decoder["name"].string
        price = decoder["price"].float
        photoURL = decoder["photoURL"].string
    }
    
}
