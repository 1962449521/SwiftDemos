//
//  CVScrollView.swift
//  demo
//
//  Created by 胡 帅 on 16/2/3.
//  Copyright © 2016年 IceChen. All rights reserved.
//

import UIKit

class CVScrollView: UIScrollView {
    @IBOutlet weak var chartView: ChartView!
    
    internal override  func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        var isHitInCharView = false
        if chartView == nil || gestureRecognizer.numberOfTouches() == 0{
            isHitInCharView = false
        } else {
            for k in 0...gestureRecognizer.numberOfTouches() - 1 {
                let point = gestureRecognizer.locationOfTouch(k, inView: self)
                let rect = self.convertRect(chartView.frame, fromView: chartView.superview)
                if rect.contains(point) {
                    isHitInCharView = true
                    break
                }
            }
        }
        if isHitInCharView {
            NSLog("hitInCharView")
        } else {
            NSLog("notHitInCharView")
        }
        return !isHitInCharView
    }
}
