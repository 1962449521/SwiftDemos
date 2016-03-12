//
//  EraserBrush.swift
//  DrawingBoard
//
//  Created by TomCat on 15-10-10.
//  Copyright (c) 2015年 Disney. All rights reserved.
//

import UIKit

class EraserBrush: PencilBrush {
    
    override func drawInPath(inout path: CGMutablePathRef) {
        CGContextSetBlendMode(self.context, CGBlendMode.Clear)
        
        super.drawInPath(&path)
    }
}
