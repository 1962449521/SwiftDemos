//
//  RectFactory.swift
//  FlyweightExampleSolution
//
//  Created by TomCat on 15-10-10.
//  Copyright (c) 2015年 Disney. All rights reserved.
//

import UIKit

class RectFactory {
    private var rects:Array<MyRect> = []
    
    func getRect(color:UIColor)->MyRect{
        for myrect in self.rects{
            if(CGColorEqualToColor(myrect.color!.CGColor, color.CGColor)){
                return myrect
            }
        }
        let rect = MyRect(color: color)
        self.rects.append(rect)
        return rect
    }
    
}
