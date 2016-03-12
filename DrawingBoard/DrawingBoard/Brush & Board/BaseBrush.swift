//
//  BaseBrush.swift
//  DrawingBoard
//
//  Created by TomCat on 15-10-10.
//  Copyright (c) 2015年 Disney. All rights reserved.
//

import CoreGraphics

protocol PaintBrush {
    
    func supportedContinuousDrawing() -> Bool
    
    func drawInPath(inout path: CGMutablePathRef)
}

class BaseBrush : NSObject, PaintBrush {
    var beginPoint: CGPoint!
    var endPoint: CGPoint!
    var lastPoint: CGPoint?
    weak var context: CGContextRef?
    
    var strokeWidth: CGFloat!
    
    func supportedContinuousDrawing() -> Bool {
        return false
    }
    
    func drawInPath(inout path: CGMutablePathRef) {
        assert(false, "must implements in subclass.")
    }
}