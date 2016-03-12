//
//  DrawModel.swift
//  DrawingBoard
//
//  Created by TomCat on 15-10-10.
//  Copyright (c) 2015年 Disney. All rights reserved.
//

import UIKit

class DrawModel: NSObject, NSCoding {
    var image:UIImage?
    var comment:String?
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(image, forKey: "image")
        aCoder.encodeObject(comment, forKey: "comment")
    }
    
    required init?(coder aDecoder: NSCoder){
         let aImage = aDecoder.decodeObjectForKey("image") as? UIImage
         let aComment = aDecoder.decodeObjectForKey("comment") as? String
            self.image = aImage
            self.comment = aComment
    }
    init(image:UIImage?, comment:String?) {
        self.image = image
        self.comment = comment
    }
}
