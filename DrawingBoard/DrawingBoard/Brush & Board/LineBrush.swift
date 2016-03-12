//
//  LineBrush.swift
//  DrawingBoard
//
//  Created by TomCat on 15-10-10.
//  Copyright (c) 2015年 Disney. All rights reserved.
//

import UIKit

class LineBrush: BaseBrush {
    
    override func drawInPath(inout path: CGMutablePathRef) {
        CGPathMoveToPoint(path, nil, beginPoint.x, beginPoint.y)
        CGPathAddLineToPoint(path, nil, endPoint.x, endPoint.y)
    }
}
