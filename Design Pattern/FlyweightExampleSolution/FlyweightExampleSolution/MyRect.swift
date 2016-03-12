//
//  MyRect.swift
//  FlyweightExampleSolution
//
//  Created by TomCat on 15-10-10.
//  Copyright (c) 2015年 Disney. All rights reserved.
//

import UIKit


struct rectAndColor {
    var color:UIColor
    var rect:MyRect
    
}

class MyRect {
    var color:UIColor?

    
    var newImage:UIImage?
    
    init(color:UIColor){
        let rect = CGRectMake(0, 0, 10, 10)
        self.color = color
        UIGraphicsBeginImageContext(rect.size)
        color.setFill()
        UIRectFill(rect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

    }
     func drawRect(rect: CGRect) {
        newImage?.drawInRect(rect)
    }
    
//    func drawInView(view:UIView, upperX:CGFloat,  upperY:CGFloat,  lowerX:CGFloat,  lowerY:CGFloat){
//        let rect:CGRect = CGRectMake(upperX, upperY, abs(lowerX-upperX), abs(lowerY-lowerX))
//        self.imageView?.drawRect(rect)
//        
//    }
}
