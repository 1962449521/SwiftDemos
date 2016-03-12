//
//  PencilBrush.swift
//  DrawingBoard
//
//  Created by TomCat on 15-10-10.
//  Copyright (c) 2015年 Disney. All rights reserved.
//

import UIKit

class PencilBrush: BaseBrush {
    
    override func drawInPath(inout path: CGMutablePathRef) {
        if let lastPoint = self.lastPoint {
            CGPathMoveToPoint(path, nil, lastPoint.x, lastPoint.y)
        } else {
            CGPathMoveToPoint(path, nil, beginPoint.x, beginPoint.y)
        }
        CGPathAddLineToPoint(path, nil, endPoint.x, endPoint.y)
    }
    
    override func supportedContinuousDrawing() -> Bool {
        return true
    }
}
