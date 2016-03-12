//
//  CustomView.swift
//  FlyweightExampleSolution
//
//  Created by TomCat on 15-10-10.
//  Copyright (c) 2015年 Disney. All rights reserved.
//

import UIKit

struct RectState {
    var rect:MyRect
    var area:CGRect
}


public class BoardView: UIView {
    var rectList:Array<RectState> = []
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        for rectState:RectState in rectList{
            rectState.rect.drawRect(rectState.area)
        }
        if (rectList.count == 0) {
            let rect2 = CGRectMake(0, 0, 50, 50)
            UIGraphicsBeginImageContext(rect.size)
            UIColor.whiteColor().setFill()
            UIRectFill(rect2)
            let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            newImage.drawInRect(rect)
        }
    }
    


}
