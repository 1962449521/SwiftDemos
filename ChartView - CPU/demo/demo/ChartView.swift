//
//  ChartView.swift
//  demo
//
//  Created by Mitty on 16/1/30.
//  Copyright © 2016年 Mitty. All rights reserved.
//

import UIKit

enum CVDisplayLevel {
    case QuaterHour// 每刻度15分钟
    case Hour      // 每刻度1小时
    case QuaterDay // 每刻度6小时
    case Day       // 每刻度1天
    case Week      // 每刻度1周
    case Month     // 每刻度1月
    case TwiceMonth  // 每刻度2月
    case SixthMonth  // 每刻度6月
    case Year        // 每刻度1年
}


protocol CVRecordHitProtocol {
    func CVRecordHit(recordIndex:Int);
}


@IBDesignable
@objc(ChartView)
class ChartView: UIView, UIGestureRecognizerDelegate {
    
// =====================成员变量区=============================== //
    
    var delegate:CVRecordHitProtocol?         // 接收点击事件的接入方
    
    /* ------------- UI定制 ---------- */
    var UI_Xlabel_Font            = UIFont.systemFontOfSize(12.0)                                      // X轴标注字体
    var UI_Xlabel_Color           = UIColor.greenColor()                                               // X轴标注颜色
    var UI_Ylabel_Font            = UIFont.systemFontOfSize(12.0)                                      // Y轴标注字体
    var UI_Ylabel_Color           = UIColor.redColor()                                                 // Y轴标注颜色
    var UI_MainGrid_Color         = UIColor.grayColor()                                                // 主栅格颜色
    var UI_MainGrid_Width         = 2.0                                                                // 主栅格粗细
    var UI_AssistGrid_Color       = UIColor.grayColor()                                                // 辅栅格颜色
    var UI_AssistGrid_Width       = 1.0                                                                // 辅栅格粗线
    var UI_HighCurve_Color        = UIColor.blueColor()                                                // 高压颜色
    var UI_HighCurve_Width        = 1.0                                                                // 高压粗细
    var UI_LowCurve_Color         = UIColor.yellowColor()                                              // 低压颜色
    var UI_LowCurve_Width         = 1.0                                                                // 低压粗细
    var UI_StartGradient_Color    = UIColor.init(red: 0.39, green: 0.76, blue: 0.7, alpha: 1)          // 渐变起色
    var UI_StartGradient_Position = 0.0                                                                // 渐变起位置
    var UI_EndGradient_Color      = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0)                  // 渐变止色
    var UI_EndGradient_Position   = 1.0                                                                // 渐变止位置
    var UI_RecordHitLine_Color    = UIColor.redColor()                                                 // 选中线颜色
    var UI_RecordHitLine_Width    = 1.0                                                                // 选中线精细
    var UI_IntersetPoint_Radius   = 10.0                                                                // 选中线与血压曲线交点半径

    // 全部设置完后调用applyCustomedUI()方法以使UI设置生效
    
    
    /* ------------- 常量设置 ---------- */
    let kPaddingBottom:CGFloat  = 60.0        // 坐标块底部留白
    let kPaddingLeft:CGFloat    = 30.0        // 坐标块左侧留白
    let kScaleResistance:CGFloat = 2.0        // 缩放手势阻力
    let kScaleMax:CGFloat = 2                 // 缩放比例上限
    let kScaleMin:CGFloat = 0.5               // 缩放比例下限
    let kPaddingVerticalReal:Float = 5        // 图形块顶部和底部留白
    
    
    /* ----------- 自动适配屏幕 -------- */
    var pYStartDisplay:CGFloat = 0            // 坐标原点的y坐标
    
    /* ------------- 数据源 ----------- */
    var dataTotal : CVRecordSet?              // 所有的数据,由接入方传参，初始化后不再改变
    var pDataDisplayed: CVRecordSet?          // 用于绘制的数据，随用户交互变化
    var maxTS = 0                             // 上次显示数据集的最大时间戳
    var minTS = 0                             // 上次显示数据集的最大时间戳
    
    /* ------------ 界面绘制变参 --------- */
    var displayLevel:CVDisplayLevel = .QuaterDay    // 显示级别
    var paddingTop:CGFloat     = 0.0          // 曲线块顶部留白 以放置点选提示
    
    var offsetX:CGFloat = 0.0                 // 伪ScrollView的对应offSet
    var scale:CGFloat   = 1.0                 // 伪ScrollView的对应scale
    
    /* ------------ 用户交互支持 -------- */
    var p_panStartX:CGFloat       = 0.0       // 拖动时最近一次已同步坐标点x
    var p_pinchStartScale:CGFloat = 1.0       // 缩放最近一次已同步比例
    var p_pinchStartX0:CGFloat    = 0.0       // 缩放启动时的两点之一
    var p_pinchStartX1:CGFloat    = 0.0       // 缩放启动时的两点之二
    var p_hitRecordIndex:Int      = -1        // 最近一次选中需要展示的选中真值
    
    weak var infoView:CVInfoView?             // 点选信息提示区

// =====================方法实现区=============================== //
    
// ------------- Interface -------------------- //
    func makeChangeVisible() {
        setNeedsDisplay()
    }
    
    func setDataSource(dataSource:CVRecordSet) {

        self.dataTotal = CVRecordSet();
        self.dataTotal?.data = dataSource.data;
        
        if (dataTotal == nil || dataTotal?.data.count == 0) {
            dataTotal = CVRecordSet()
            dataTotal?.maxHigh = 220
            dataTotal?.minLow = 30
            dataTotal?.minTS = Int(NSDate().timeIntervalSince1970)
        }
        
        if (infoView != nil) {
            infoView?.removeFromSuperview()
            p_hitRecordIndex = -1
            paddingTop = 0.0
        }
        offsetX = 0
        scale   = 1
        
    }
    
    func moveToTimeInterval(tsReal:Int) {
        let tsDisplay = self.frame.size.width / 2.0
        
        let startXDisplay = kPaddingLeft
        let endXDisplay = self.frame.size.width
        let displayInterval = CGFloat(endXDisplay - startXDisplay)
        
        offsetX = CGFloat(tsReal - realDateStart_once()) * displayInterval / CGFloat(realDateInterval()) + startXDisplay - tsDisplay

    }
    
    func setDisplayLevel(level:Int) {
        let levels:[CVDisplayLevel] = [CVDisplayLevel.Day, CVDisplayLevel.Week, CVDisplayLevel.Month]
        
        let startXDisplay = kPaddingLeft
        let endXDisplay = self.frame.size.width
        let displayInterval = CGFloat(endXDisplay - startXDisplay)
        let centerDisplayX = (self.frame.width - kPaddingLeft)/2 + kPaddingLeft
        let centerRealX = XRealFromDisplayValue(centerDisplayX)
        
        self.displayLevel = levels[level]
        
        if (infoView != nil) {
            infoView?.removeFromSuperview()
            p_hitRecordIndex = -1
            paddingTop = 0.0
        }
        
        scale = 1.0
        offsetX = CGFloat(centerRealX - realDateStart_once()) * displayInterval / CGFloat(realDateInterval()) + startXDisplay - centerDisplayX

    }
    
    
    
// ------------- initialization -------------------- //
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.customInit()
    }
    
    
    
    func customInit () {
        if (dataTotal == nil || dataTotal?.data.count == 0) {
            dataTotal = CVRecordSet()
            dataTotal?.maxHigh = 220
            dataTotal?.minLow = 30
            dataTotal?.minTS = Int(NSDate().timeIntervalSince1970)
        }
        self.displayLevel = .Week
        self.scale = 1.0
        pDataDisplayed = dataTotal!.copy() as? CVRecordSet
        pDataDisplayed?.data = NSMutableArray()
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: "handlePinchGesture:")
        self.addGestureRecognizer(pinchGesture)
        pinchGesture.delegate = self
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        self.addGestureRecognizer(panGesture)
        panGesture.delegate = self
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        self.addGestureRecognizer(tapGesture)

    }
    
    override func layoutSubviews() {
        self.pYStartDisplay = self.frame.size.height - kPaddingBottom

    }

// ----------------- draw ------------------------- //
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext();
        filterData4Display()
        drawGrid()
        CGContextSaveGState(context);
        drawDataCurveChart()
        drawGradientRect()
        CGContextRestoreGState(context);
        drawHitedLine()
    }
    
    func XDisplayLabelsWidthTotal(willScale:CGFloat) ->CGFloat {
        var perLabelLength:CGFloat = 0
        var labelCount = 0
        let padding:CGFloat = 1
        switch self.displayLevel {
        case .QuaterDay :
            perLabelLength = UI_Xlabel_Font.pointSize * (2.5 + padding)
            labelCount = Int(floor(4.0 / willScale))
        case .Day:
            perLabelLength = UI_Xlabel_Font.pointSize * (3.5 + padding)
            labelCount = Int(floor(7.0 / willScale))

        case .Month:
            perLabelLength = UI_Xlabel_Font.pointSize * (2 + padding)
            labelCount = Int(floor(6.0 / willScale))
        default:
            break
        }
        return  CGFloat(perLabelLength * CGFloat(labelCount))
    }
    
    // 真实值向坐标的转换 y轴
    func YDisPlayFromRealValue(real:Float) -> CGFloat {
        let yStartReal:Float    = floor(pDataDisplayed!.minLow) - kPaddingVerticalReal
        let yEndReal:Float      = ceil(pDataDisplayed!.maxHigh) + kPaddingVerticalReal
        let yDistanceReal:Float = yEndReal - yStartReal
        
        let yDistanceDisplay = pYStartDisplay - paddingTop
        return pYStartDisplay - (CGFloat(real - yStartReal) * yDistanceDisplay / CGFloat(yDistanceReal))
    }
    
    // 坐标值向真实值的转换 y轴
    func YRealFromDisplayValue(display:CGFloat) -> Float {
        let yStartReal:Float    = floor(pDataDisplayed!.minLow) - kPaddingVerticalReal
        let yEndReal:Float      = ceil(pDataDisplayed!.maxHigh) + kPaddingVerticalReal
        let yDistanceReal:Float = yEndReal - yStartReal
        
        let yDistanceDisplay = pYStartDisplay - paddingTop
        return (Float(pYStartDisplay - display)) * yDistanceReal / Float(yDistanceDisplay)
    }
    
    // 控件初始化时的原点真值 x轴
    func realDateStart_once() ->Int {
        switch displayLevel {
        case .Hour:
            fallthrough;
        case .QuaterHour:
            fallthrough;
        case .QuaterDay:
            return CVUtil.nearestDayFrom(self.dataTotal!.minTS, isForward: false)
        case .Week:
            fallthrough;
        case .Day:
            return CVUtil.nearestWeekFrom(self.dataTotal!.minTS, isForward: false)
        case .TwiceMonth:
            fallthrough;
        case .SixthMonth:
            fallthrough;
        case .Month:
            return CVUtil.nearestMonthFrom(self.dataTotal!.minTS, isForward: false)
        case .Year:
            return CVUtil.nearestYearFrom(self.dataTotal!.minTS, isForward: false)
        }
    }
    
    // 即时原点真值 x轴
    func realDateStart() ->Int {
        return XRealFromDisplayValue(kPaddingLeft)
    }

    // 即时屏宽真值
    func realDateInterval() ->Int {
        switch displayLevel {
        case .QuaterDay:
            return  Int(3600 * 4 * 6 / scale)
        case .Hour:
            return  Int(3600 * 4 * 1 / scale)
        case .QuaterHour:
            return  Int(3600 * 4 * 0.25 / scale)
        case .Day:
            return  Int(3600 * 4 * 24 / scale)
        case .Week:
            return  Int(3600 * 4 * 7 * 24 / scale)
        case .Month:
            return  Int(3600 * 4 * 30 * 24 / scale)
        case .TwiceMonth:
            return  Int(3600 * 4 * 30 * 24 * 2 / scale)
        case .SixthMonth:
            return  Int(3600 * 4 * 30 * 24 * 6 / scale)
        case .Year:
            return Int(3600 * 24 * 365 * 3 / scale)
        }
    }
    
    // 真实值向坐标的转换 x轴
    func XDisPlayFromRealValue(real:Int) -> CGFloat {
        let startXDisplay = kPaddingLeft
        let endXDisplay = self.frame.size.width
        let displayInterval = Float(endXDisplay - startXDisplay)
        
        var display:CGFloat = CGFloat(Float(real - realDateStart_once()) * displayInterval / Float(realDateInterval())) - offsetX + kPaddingLeft
        if (display < startXDisplay || display > endXDisplay) {
            display = -1.0
        }
        return display
    }
    
    // 真实值向坐标的转换 x轴 不判界外
    func XDisPlayFromRealValue2(real:Int) -> CGFloat {
        let startXDisplay = kPaddingLeft
        let endXDisplay = self.frame.size.width
        let displayInterval = Float(endXDisplay - startXDisplay)
        
        let display:CGFloat = CGFloat(Float(real - realDateStart_once()) * displayInterval / Float(realDateInterval())) - offsetX + kPaddingLeft
        return display
    }

    
    // 坐标值向真实值的转换 x轴
    func XRealFromDisplayValue(display:CGFloat) -> Int {
        let startXDisplay = kPaddingLeft
        let endXDisplay = self.frame.size.width
        let displayInterval = Float(endXDisplay - startXDisplay)

        let real =  Float(display - startXDisplay + offsetX) * Float(realDateInterval()) / displayInterval
        return Int(real) +  realDateStart_once()
    }
    
    
    // 绘制Y轴网格
    func drawGridofYAxis() {
        
        let axisMainGridPath   = CGPathCreateMutable() // 主网格
        let axisAssistGridPath = CGPathCreateMutable() // 辅网格
        
        let topReal = Float(paddingTop) * (ceil(pDataDisplayed!.maxHigh) - floor(pDataDisplayed!.minLow) + 2 * kPaddingVerticalReal) / Float(self.frame.size.height  - paddingTop - kPaddingBottom)
        
        let yStartReal:Float    = floor(pDataDisplayed!.minLow) - kPaddingVerticalReal
        let yEndReal:Float      = ceil(pDataDisplayed!.maxHigh) + kPaddingVerticalReal + topReal
        
        for var curYReal = yStartReal; curYReal <= yEndReal; curYReal += 1 {
            let display = self.YDisPlayFromRealValue(curYReal)
            if Int(curYReal) % 10 == 0 {
                CGPathMoveToPoint(axisMainGridPath, nil, kPaddingLeft, display)
                CGPathAddLineToPoint(axisMainGridPath, nil, self.frame.size.width, display)
                
                let strAxisLabelY:NSString = NSString(format: "%5d", Int(curYReal))
                strAxisLabelY.drawAtPoint(CGPoint(x: 0, y: display), withAttributes: [NSFontAttributeName : UI_Ylabel_Font,NSForegroundColorAttributeName: UI_Ylabel_Color])
            } else {
                CGPathMoveToPoint(axisAssistGridPath, nil, kPaddingLeft, display)
                CGPathAddLineToPoint(axisAssistGridPath, nil, self.frame.size.width, display)
            }
        }
        
        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), UI_MainGrid_Color.CGColor)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), CGFloat(UI_MainGrid_Width))
        CGContextAddPath(UIGraphicsGetCurrentContext(), axisMainGridPath)
        CGContextDrawPath(UIGraphicsGetCurrentContext(), CGPathDrawingMode.Stroke)
    }
    
    // 绘制X轴网格
    func drawGridofXAxis(level:CVDisplayLevel) {
        
        let axisMainGridPath   = CGPathCreateMutable() // 主网格
        let realStartX = realDateStart()
        
        switch level {
        case .QuaterHour: //每刻度15分钟
            let startTS = CVUtil.nearestHourFrom(realStartX, isForward: false)
            var isSubXLabelExisted = 0
            var firstTS = 0
            for var curTS = startTS; curTS <= startTS + 2 * Int(3600/kScaleMin); curTS += 60*15 {
                let displayX = XDisPlayFromRealValue(curTS)
                if (displayX > 0) {
                    if (firstTS == 0) {
                        firstTS = curTS
                    }
                    
                    let cvDate = CVUtil.CVDateFromTimeInterval(curTS)
                    var strAxisLabelX = NSString(format: "%2d:%2d", cvDate.hour, cvDate.minute)
                    if cvDate.minute == 0 {
                        strAxisLabelX = NSString(format: "%2d:00", cvDate.hour)
                    }
                    
                    CGPathMoveToPoint(axisMainGridPath, nil, displayX, 0)
                    CGPathAddLineToPoint(axisMainGridPath, nil, displayX, self.frame.size.height - kPaddingBottom)
                    strAxisLabelX.drawAtPoint(CGPoint(x: displayX, y: self.frame.size.height - kPaddingBottom + 5), withAttributes: [NSFontAttributeName : UI_Xlabel_Font,NSForegroundColorAttributeName: UI_Xlabel_Color])
                    
                }
            }
            if (firstTS == 0) { firstTS = startTS }
            
            if (isSubXLabelExisted == 0 && firstTS != 0) {
                let cvDate = CVUtil.CVDateFromTimeInterval(firstTS)
                let strAxisLabelXSub = NSString(format: "%4d年%2d月%2d日 %2d时", cvDate.year, cvDate.month, cvDate.day, cvDate.hour)
                strAxisLabelXSub.drawAtPoint(CGPoint(x: kPaddingLeft, y: self.frame.size.height - kPaddingBottom + 32), withAttributes: [NSFontAttributeName : UI_Xlabel_Font,NSForegroundColorAttributeName: UI_Xlabel_Color])
                isSubXLabelExisted = 1
            }
            
            CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), UI_MainGrid_Color.CGColor)
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), CGFloat(UI_MainGrid_Width))
            CGContextAddPath(UIGraphicsGetCurrentContext(), axisMainGridPath)
            CGContextDrawPath(UIGraphicsGetCurrentContext(), CGPathDrawingMode.Stroke)
            
    
        case .Hour://每刻度一小时
            let startTS = CVUtil.nearestHourFrom(realStartX, isForward: false)
            var isSubXLabelExisted = 0
            var firstTS = 0
            for var curTS = startTS; curTS <= startTS + Int(3600*6/kScaleMin); curTS += 3600 {
                let displayX = XDisPlayFromRealValue(curTS)
                if (displayX > 0) {
                    if (firstTS == 0) {
                        firstTS = curTS
                    }
                    
                    let cvDate = CVUtil.CVDateFromTimeInterval(curTS)
                    let hour = cvDate.hour
                    let strAxisLabelX = NSString(format: "%2d:00", hour)

                    CGPathMoveToPoint(axisMainGridPath, nil, displayX, 0)
                    CGPathAddLineToPoint(axisMainGridPath, nil, displayX, self.frame.size.height - kPaddingBottom)
                    strAxisLabelX.drawAtPoint(CGPoint(x: displayX, y: self.frame.size.height - kPaddingBottom + 5), withAttributes: [NSFontAttributeName : UI_Xlabel_Font,NSForegroundColorAttributeName: UI_Xlabel_Color])
                }
            }
            if (firstTS == 0) { firstTS = startTS }

            if (isSubXLabelExisted == 0 && firstTS != 0) {
                let cvDate = CVUtil.CVDateFromTimeInterval(firstTS)
                let strWeekSet = ["", "周一", "周二", "周三", "周四", "周五", "周六", "周日"]
                let strAxisLabelXSub = NSString(format: "%4d年%2d月%2d日 %@", cvDate.year, cvDate.month, cvDate.day, strWeekSet[cvDate.week])
                strAxisLabelXSub.drawAtPoint(CGPoint(x: kPaddingLeft, y: self.frame.size.height - kPaddingBottom + 32), withAttributes: [NSFontAttributeName : UI_Xlabel_Font,NSForegroundColorAttributeName: UI_Xlabel_Color])
                isSubXLabelExisted = 1
            }
            
            CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), UI_MainGrid_Color.CGColor)
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), CGFloat(UI_MainGrid_Width))
            CGContextAddPath(UIGraphicsGetCurrentContext(), axisMainGridPath)
            CGContextDrawPath(UIGraphicsGetCurrentContext(), CGPathDrawingMode.Stroke)
            
            
        case .QuaterDay://每刻度 6小时
            let startTS = CVUtil.nearestHourFrom(realStartX, isForward: false)
            var isSubXLabelExisted = 0
            var firstTS = 0
            for var curTS = startTS; curTS <= startTS + Int(3600*24/kScaleMin); curTS += 3600 {
                let displayX = XDisPlayFromRealValue(curTS)
                if (displayX > 0) {
                    let cvDate = CVUtil.CVDateFromTimeInterval(curTS)
                    let hour = cvDate.hour
                    if  hour % 6 != 0 {
                    } else {
                        if (firstTS == 0) {
                            firstTS = curTS
                        }

                        CGPathMoveToPoint(axisMainGridPath, nil, displayX, 0)
                        CGPathAddLineToPoint(axisMainGridPath, nil, displayX, self.frame.size.height - kPaddingBottom)
                        
                        let strLabelSet = ["00:00", "06:00", "12:00", "18:00", "00:00"]
                        let strAxisLabelX = NSString(string: strLabelSet[hour / 6])
                        strAxisLabelX.drawAtPoint(CGPoint(x: displayX, y: self.frame.size.height - kPaddingBottom + 5), withAttributes: [NSFontAttributeName : UI_Xlabel_Font,NSForegroundColorAttributeName: UI_Xlabel_Color])
                    }
                }
            }
            if (firstTS == 0) { firstTS = startTS }

            if (isSubXLabelExisted == 0 && firstTS != 0) {
                let cvDate = CVUtil.CVDateFromTimeInterval(firstTS)
                let strWeekSet = ["", "周一", "周二", "周三", "周四", "周五", "周六", "周日"]
                let strAxisLabelXSub = NSString(format: "%4d年%2d月%2d日 %@", cvDate.year, cvDate.month, cvDate.day, strWeekSet[cvDate.week])
                strAxisLabelXSub.drawAtPoint(CGPoint(x: kPaddingLeft, y: self.frame.size.height - kPaddingBottom + 32), withAttributes: [NSFontAttributeName : UI_Xlabel_Font,NSForegroundColorAttributeName: UI_Xlabel_Color])
                isSubXLabelExisted = 1
            }
            
            CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), UI_MainGrid_Color.CGColor)
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), CGFloat(UI_MainGrid_Width))
            CGContextAddPath(UIGraphicsGetCurrentContext(), axisMainGridPath)
            CGContextDrawPath(UIGraphicsGetCurrentContext(), CGPathDrawingMode.Stroke)
        case .Day:
            // 每刻度一天
            let startTS = CVUtil.nearestDayFrom(realStartX, isForward: false)
            var isSubXLabelExisted = 0
            var firstTS = 0
            
            for var curTS = startTS; curTS <= startTS + Int(3600*24*7/kScaleMin); curTS += 3600*24 {
                let displayX = XDisPlayFromRealValue(curTS)
                if (displayX > 0) {
                    if (firstTS == 0) {
                        firstTS = curTS
                    }
                    
                    let cvDate = CVUtil.CVDateFromTimeInterval(curTS)
                    let week = cvDate.week
                    
                    let strWeekSet = ["", "周一", "周二", "周三", "周四", "周五", "周六", "周日"]
                    let strAxisLabelX = NSString(string: "\(strWeekSet[week]) \(cvDate.day)")
                    strAxisLabelX.drawAtPoint(CGPoint(x: displayX, y: self.frame.size.height - kPaddingBottom + 5), withAttributes: [NSFontAttributeName : UI_Xlabel_Font,NSForegroundColorAttributeName: UI_Xlabel_Color])
                    
                    CGPathMoveToPoint(axisMainGridPath, nil, displayX, 0)
                    CGPathAddLineToPoint(axisMainGridPath, nil, displayX, self.frame.size.height - kPaddingBottom)

                }
            }
            if (firstTS == 0) { firstTS = startTS }

            if (isSubXLabelExisted == 0 && firstTS != 0) {
                let cvDate = CVUtil.CVDateFromTimeInterval(firstTS)
                let strAxisLabelXSub = NSString(format: "%4d年%2d月第%2d周", cvDate.year, cvDate.month, cvDate.weekOfMonth)
                strAxisLabelXSub.drawAtPoint(CGPoint(x: kPaddingLeft, y: self.frame.size.height - kPaddingBottom + 32), withAttributes: [NSFontAttributeName : UI_Xlabel_Font,NSForegroundColorAttributeName: UI_Xlabel_Color])
                isSubXLabelExisted = 1
            }
            
            CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), UI_MainGrid_Color.CGColor)
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), CGFloat(UI_MainGrid_Width))
            CGContextAddPath(UIGraphicsGetCurrentContext(), axisMainGridPath)
            CGContextDrawPath(UIGraphicsGetCurrentContext(), CGPathDrawingMode.Stroke)

            
        case .Week://每刻度一周
            let startTS = CVUtil.nearestDayFrom(realStartX, isForward: false)
            var isSubXLabelExisted = 0
            var firstTS = 0
            
            for var curTS = startTS; curTS <= startTS + Int(3600*24*7*4/kScaleMin); curTS += 3600*24 {
                let displayX = XDisPlayFromRealValue(curTS)
                if (displayX > 0) {
                    let cvDate = CVUtil.CVDateFromTimeInterval(curTS)
                    let week = cvDate.week
                    
                    let strWeekSet = ["", "周一", "周二", "周三", "周四", "周五", "周六", "周日"]
                    let strAxisLabelX = NSString(string: "\(strWeekSet[week]) \(cvDate.day)")
                    
                    
                    if  week == 1 {
                        if (firstTS == 0) {
                            firstTS = curTS
                        }
                        strAxisLabelX.drawAtPoint(CGPoint(x: displayX, y: self.frame.size.height - kPaddingBottom + 5), withAttributes: [NSFontAttributeName : UI_Xlabel_Font,NSForegroundColorAttributeName: UI_Xlabel_Color])
                        CGPathMoveToPoint(axisMainGridPath, nil, displayX, 0)
                        CGPathAddLineToPoint(axisMainGridPath, nil, displayX, self.frame.size.height - kPaddingBottom)
                    }
                }
            }
            if (firstTS == 0) { firstTS = startTS }

            if (isSubXLabelExisted == 0 && firstTS != 0) {
                let cvDate = CVUtil.CVDateFromTimeInterval(firstTS)
                let strAxisLabelXSub = NSString(format: "%4d年%2d月", cvDate.year, cvDate.month)
                strAxisLabelXSub.drawAtPoint(CGPoint(x: kPaddingLeft, y: self.frame.size.height - kPaddingBottom + 32), withAttributes: [NSFontAttributeName : UI_Xlabel_Font,NSForegroundColorAttributeName: UI_Xlabel_Color])
                isSubXLabelExisted = 1
            }
            
            CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), UI_MainGrid_Color.CGColor)
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), CGFloat(UI_MainGrid_Width))
            CGContextAddPath(UIGraphicsGetCurrentContext(), axisMainGridPath)
            CGContextDrawPath(UIGraphicsGetCurrentContext(), CGPathDrawingMode.Stroke)
            
        case .Month:
            // 每刻度一月
            let startTS = CVUtil.nearestDayFrom(realStartX, isForward: false)
            var isSubXLabelExisted = 0
            var firstTS = 0
            
            var count = 0
            var curTS = startTS
            
            while count < 6 {
                curTS = CVUtil.nearestMonthFrom(curTS, isForward: true)
                let displayX = XDisPlayFromRealValue(curTS)
                if (displayX > 0) {
                    
                    let cvDate = CVUtil.CVDateFromTimeInterval(curTS)
                    let day = cvDate.day
                    if  day != 1 {
                    } else {
                        if (firstTS == 0) {
                            firstTS = curTS
                        }
                        
                        CGPathMoveToPoint(axisMainGridPath, nil, displayX, 0)
                        CGPathAddLineToPoint(axisMainGridPath, nil, displayX, self.frame.size.height - kPaddingBottom)
                        
                        let strAxisLabelX = NSString(format: "%2d月", cvDate.month)
                        strAxisLabelX.drawAtPoint(CGPoint(x: displayX, y: self.frame.size.height - kPaddingBottom + 5), withAttributes: [NSFontAttributeName : UI_Xlabel_Font,NSForegroundColorAttributeName: UI_Xlabel_Color])
                    }
                }
                count += 1
                curTS += 3600
            }
            if (firstTS == 0) { firstTS = startTS }

            if (isSubXLabelExisted == 0 && firstTS != 0) {
                let cvDate = CVUtil.CVDateFromTimeInterval(firstTS)
                let strAxisLabelXSub = NSString(format: "%4d年", cvDate.year)
                strAxisLabelXSub.drawAtPoint(CGPoint(x: kPaddingLeft, y: self.frame.size.height - kPaddingBottom + 32), withAttributes: [NSFontAttributeName : UI_Xlabel_Font,NSForegroundColorAttributeName: UI_Xlabel_Color])
                isSubXLabelExisted = 1
            }
            
            
            CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), UI_MainGrid_Color.CGColor)
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), CGFloat(UI_MainGrid_Width))
            CGContextAddPath(UIGraphicsGetCurrentContext(), axisMainGridPath)
            CGContextDrawPath(UIGraphicsGetCurrentContext(), CGPathDrawingMode.Stroke)
            
        case .TwiceMonth:
            // 每刻度两月
            let startTS = CVUtil.nearestDayFrom(realStartX, isForward: false)
            var isSubXLabelExisted = 0
            var firstTS = 0
            
            var count = 0
            var curTS = startTS
            
            while count < 6 * 2 {
                curTS = CVUtil.nearestMonthFrom(curTS, isForward: true)

                let displayX = XDisPlayFromRealValue(curTS)
                if (displayX > 0) {
                    
                    let cvDate = CVUtil.CVDateFromTimeInterval(curTS)
                    let day = cvDate.day
                    if  day != 1 {
                    } else if (cvDate.month % 2 == 1){
                        if (firstTS == 0) {
                            firstTS = curTS
                        }
                        
                        CGPathMoveToPoint(axisMainGridPath, nil, displayX, 0)
                        CGPathAddLineToPoint(axisMainGridPath, nil, displayX, self.frame.size.height - kPaddingBottom)
                        
                        let strAxisLabelX = NSString(format: "%2d月", cvDate.month)
                        strAxisLabelX.drawAtPoint(CGPoint(x: displayX, y: self.frame.size.height - kPaddingBottom + 5), withAttributes: [NSFontAttributeName : UI_Xlabel_Font,NSForegroundColorAttributeName: UI_Xlabel_Color])
                    }
                }
                count += 1
                curTS += 3600

            }
            if (firstTS == 0) { firstTS = startTS }

            if (isSubXLabelExisted == 0 ) {
                let cvDate = CVUtil.CVDateFromTimeInterval(firstTS)
                let strAxisLabelXSub = NSString(format: "%4d年", cvDate.year)
                strAxisLabelXSub.drawAtPoint(CGPoint(x: kPaddingLeft, y: self.frame.size.height - kPaddingBottom + 32), withAttributes: [NSFontAttributeName : UI_Xlabel_Font,NSForegroundColorAttributeName: UI_Xlabel_Color])
                isSubXLabelExisted = 1
            }
            
            
            CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), UI_MainGrid_Color.CGColor)
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), CGFloat(UI_MainGrid_Width))
            CGContextAddPath(UIGraphicsGetCurrentContext(), axisMainGridPath)
            CGContextDrawPath(UIGraphicsGetCurrentContext(), CGPathDrawingMode.Stroke)
        case .SixthMonth:
            // 每刻度6月
            let startTS = CVUtil.nearestDayFrom(realStartX, isForward: false)
            var isSubXLabelExisted = 0
            var firstTS = 0
            
            var count = 0
            var curTS = startTS
            
            while count < 6 * 6 {
                curTS = CVUtil.nearestMonthFrom(curTS, isForward: true)
                let displayX = XDisPlayFromRealValue(curTS)
                if (displayX > 0) {
                    
                    let cvDate = CVUtil.CVDateFromTimeInterval(curTS)
                    let day = cvDate.day
                    if  day != 1 {
                    } else if (cvDate.month % 6 == 1){
                        if (firstTS == 0) {
                            firstTS = curTS
                        }
                        
                        CGPathMoveToPoint(axisMainGridPath, nil, displayX, 0)
                        CGPathAddLineToPoint(axisMainGridPath, nil, displayX, self.frame.size.height - kPaddingBottom)
                        
                        let strAxisLabelX = NSString(format: "%2d月", cvDate.month)
                        strAxisLabelX.drawAtPoint(CGPoint(x: displayX, y: self.frame.size.height - kPaddingBottom + 5), withAttributes: [NSFontAttributeName : UI_Xlabel_Font,NSForegroundColorAttributeName: UI_Xlabel_Color])
                    }
                }
                count += 1
                curTS += 3600

            }
            if (firstTS == 0) { firstTS = startTS }

            if (isSubXLabelExisted == 0 ) {
                let cvDate = CVUtil.CVDateFromTimeInterval(firstTS)
                let strAxisLabelXSub = NSString(format: "%4d年", cvDate.year)
                strAxisLabelXSub.drawAtPoint(CGPoint(x: kPaddingLeft, y: self.frame.size.height - kPaddingBottom + 32), withAttributes: [NSFontAttributeName : UI_Xlabel_Font,NSForegroundColorAttributeName: UI_Xlabel_Color])
                isSubXLabelExisted = 1
            }
            
            
            CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), UI_MainGrid_Color.CGColor)
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), CGFloat(UI_MainGrid_Width))
            CGContextAddPath(UIGraphicsGetCurrentContext(), axisMainGridPath)
            CGContextDrawPath(UIGraphicsGetCurrentContext(), CGPathDrawingMode.Stroke)
            
        case .Year:
            // 每刻度1月
            let startTS = CVUtil.nearestDayFrom(realStartX, isForward: false)
            var firstTS = 0
            
            var count = 0
            var curTS = startTS
            
            while count < 6 * 6 {
                curTS = CVUtil.nearestYearFrom(curTS, isForward: true)
                let displayX = XDisPlayFromRealValue(curTS)
                if (displayX > 0) {
                    
                    let cvDate = CVUtil.CVDateFromTimeInterval(curTS)
                    let day = cvDate.day
                    if  day != 1 || cvDate.month != 1 {
                    } else {
                        if (firstTS == 0) {
                            firstTS = curTS
                        }
                        
                        CGPathMoveToPoint(axisMainGridPath, nil, displayX, 0)
                        CGPathAddLineToPoint(axisMainGridPath, nil, displayX, self.frame.size.height - kPaddingBottom)
                        
                        let strAxisLabelX = NSString(format: "%2d", cvDate.year)
                        strAxisLabelX.drawAtPoint(CGPoint(x: displayX, y: self.frame.size.height - kPaddingBottom + 5), withAttributes: [NSFontAttributeName : UI_Xlabel_Font,NSForegroundColorAttributeName: UI_Xlabel_Color])
                        
                    }
                }
                count += 1
                curTS += 3600
                
            }
            
            CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), UI_MainGrid_Color.CGColor)
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), CGFloat(UI_MainGrid_Width))
            CGContextAddPath(UIGraphicsGetCurrentContext(), axisMainGridPath)
            CGContextDrawPath(UIGraphicsGetCurrentContext(), CGPathDrawingMode.Stroke)
        }
        
    }
    
    // 绘制坐标网格
    func drawGrid() {
        let startXDisplay = kPaddingLeft
        let endXDisplay = self.frame.size.width
        let startYDisplay = pYStartDisplay
        let endYDisplay = paddingTop
        
        let axisPath = CGPathCreateMutable()
        
        CGPathMoveToPoint(axisPath, nil, startXDisplay, endYDisplay)
        CGPathAddLineToPoint(axisPath, nil, startXDisplay, startYDisplay)
        CGPathAddLineToPoint(axisPath, nil, endXDisplay, startYDisplay)
        
        
        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), UI_AssistGrid_Color.CGColor)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), CGFloat(UI_AssistGrid_Width))
        CGContextAddPath(UIGraphicsGetCurrentContext(), axisPath)
        CGContextDrawPath(UIGraphicsGetCurrentContext(), CGPathDrawingMode.Stroke)
        

        
        if minTS != pDataDisplayed?.minTS || maxTS != pDataDisplayed?.maxTS {
            drawGridofYAxis()
        }
        
        drawGridofXAxis(self.displayLevel)
        
        
        
    }
    
    // 筛选需要进行绘制操作的数据集
    func filterData4Display() {
        if (dataTotal?.data.count == 0) {
            pDataDisplayed?.data = NSMutableArray();
            return
        }
        let leftReal = XRealFromDisplayValue(kPaddingLeft);
        let rightReal = XRealFromDisplayValue(self.frame.size.width)
        
        let dateSet:NSMutableArray = (self.dataTotal?.data)!
        
        // 与rightReal相等，或比其小的最大数， 没有时（图均在右边界），取0
        var right = findIndexLTorEqual(rightReal, dateSet: dateSet, start: 0, end: dateSet.count-1)
        
        // 与letfReal相等，或比其大的最小数， 没有时（图均在左边界），取count - 1
        var left = findIndexGTorEqual(leftReal,  dateSet: dateSet, start: 0, end: dateSet.count-1)
        
        if left == right
            && ((dateSet[left] as! CVRecord).date <= leftReal
            || dateSet[left].date >= rightReal) {
            return; // 在屏幕一侧，不再绘制
        } else if (left > right){//中间没有任何点
            left -= 1
            right += 1
            if (left < 0) { left = 0}
            if (right > dateSet.count - 1) { right = dateSet.count - 1}
        } else {// left,right有一点或两点在屏幕内
            if ((dateSet[left] as! CVRecord).date > leftReal) { left -= 1}
            if (dateSet[right].date < rightReal) {right += 1}
            if (left < 0) { left = 0}
            if (right > dateSet.count - 1) { right = dateSet.count - 1}
        }
        let data = self.dataTotal?.data.subarrayWithRange(NSMakeRange(left, right-left+1))
        pDataDisplayed?.data = NSMutableArray.init(array: data!)
    }
    
    // 限制数据绘制在非标签区域 
    func drawClipRect() {
        let clip = UIBezierPath()
        clip.moveToPoint(CGPoint(x: kPaddingLeft, y: paddingTop))
        clip.addLineToPoint(CGPoint(x: kPaddingLeft, y: self.frame.size.height - kPaddingBottom))
        clip.addLineToPoint(CGPoint(x: self.frame.size.width, y: self.frame.size.height - kPaddingBottom))
        clip.addLineToPoint(CGPoint(x: self.frame.size.width, y: paddingTop))
        clip.closePath()
        clip.addClip()

    }
    
    // 绘制数据
    func drawDataCurveChart() {
        if (pDataDisplayed?.data.count == 0) {
            return
        }
        let dataSet = pDataDisplayed?.data
        if (dataSet?.count == 1) {

            var rectHigh = CGRectMake(0, 0, 10, 10);
            var rectLow = CGRectMake(0, 0, 10, 10);
            let pointHigh = CGPoint(x: XDisPlayFromRealValue2((dataSet![0] as! CVRecord) .date), y: YDisPlayFromRealValue((dataSet![0]  as! CVRecord).highValue))
            let pointLow = CGPoint(x: XDisPlayFromRealValue2((dataSet![0] as! CVRecord) .date), y: YDisPlayFromRealValue((dataSet![0]  as! CVRecord).lowValue))
            rectHigh.origin = CGPointMake(pointHigh.x - rectHigh.width/2, pointHigh.y - rectHigh.height/2);
            rectLow.origin = CGPointMake(pointLow.x - rectLow.width/2, pointLow.y - rectLow.height/2);
            
            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), UI_HighCurve_Color.CGColor)
            CGContextFillEllipseInRect(UIGraphicsGetCurrentContext(), rectHigh);
            
            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), UI_LowCurve_Color.CGColor)
            CGContextFillEllipseInRect(UIGraphicsGetCurrentContext(), rectLow);
            
            return;
        }

        drawClipRect()
        
        
        let topPath = CGPathCreateMutable()
        let bottomPath = CGPathCreateMutable()
        
        let curvePath = UIBezierPath()
        curvePath.lineWidth = 2
        
        let point = CGPoint(x: XDisPlayFromRealValue2((dataSet![0] as! CVRecord) .date), y: YDisPlayFromRealValue((dataSet![0]  as! CVRecord).highValue))
//        NSLog("startpoinx:\(point.x), startpointy:\(point.y)")
        curvePath.moveToPoint(point)
        
        CGPathMoveToPoint(topPath, nil, point.x, point.y)
        
        for var curIndex = 1; curIndex < dataSet!.count; curIndex++ {
            let point = CGPoint(x: XDisPlayFromRealValue2((dataSet![curIndex]  as! CVRecord).date), y: YDisPlayFromRealValue((dataSet![curIndex]  as! CVRecord).highValue))
            curvePath.addLineToPoint(point)
            CGPathAddLineToPoint(topPath, nil, point.x, point.y)
        }
        
        for var curIndex = dataSet!.count - 1; curIndex >= 0; curIndex-- {
            let point = CGPoint(x: XDisPlayFromRealValue2((dataSet![curIndex]  as! CVRecord).date), y: YDisPlayFromRealValue((dataSet![curIndex]  as! CVRecord).lowValue))
            if (curIndex == dataSet!.count - 1) {
                CGPathMoveToPoint(bottomPath, nil, point.x, point.y)
            } else {
                CGPathAddLineToPoint(bottomPath, nil, point.x, point.y)
            }
            curvePath.addLineToPoint(point)
        }
        curvePath.closePath()
//        curvePath.stroke()
        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), UI_HighCurve_Color.CGColor)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), CGFloat(UI_HighCurve_Width))
        CGContextAddPath(UIGraphicsGetCurrentContext(), topPath)
        CGContextDrawPath(UIGraphicsGetCurrentContext(), CGPathDrawingMode.Stroke)
        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), UI_LowCurve_Color.CGColor)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), CGFloat(UI_LowCurve_Width))
        CGContextAddPath(UIGraphicsGetCurrentContext(), bottomPath)
        CGContextDrawPath(UIGraphicsGetCurrentContext(), CGPathDrawingMode.Stroke)

        curvePath.addClip()
    }
    
    // 绘制选中
    func drawHitedLine() {
        if (p_hitRecordIndex > -1 && p_hitRecordIndex < dataTotal!.data.count) {
            let hitRecord:CVRecord = dataTotal!.data[p_hitRecordIndex] as! CVRecord
            let displayX = XDisPlayFromRealValue(hitRecord.date)
            let hitHighLightLinePath   = CGPathCreateMutable() // 主网格
            CGPathMoveToPoint(hitHighLightLinePath, nil, displayX, 0)
            CGPathAddLineToPoint(hitHighLightLinePath, nil, displayX, self.frame.size.height - kPaddingBottom)
            CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), UI_RecordHitLine_Color.CGColor)
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), CGFloat(UI_RecordHitLine_Width))
            CGContextAddPath(UIGraphicsGetCurrentContext(), hitHighLightLinePath)
            CGContextDrawPath(UIGraphicsGetCurrentContext(), CGPathDrawingMode.Stroke)
            
            let image = UIImage(named: "IntersectPoint")
            image?.drawInRect(CGRectMake(displayX - CGFloat(UI_IntersetPoint_Radius)/2, YDisPlayFromRealValue(hitRecord.highValue) - CGFloat(UI_IntersetPoint_Radius)/2, CGFloat(UI_IntersetPoint_Radius), CGFloat(UI_IntersetPoint_Radius)))
            image?.drawInRect(CGRectMake(displayX - CGFloat(UI_IntersetPoint_Radius)/2, YDisPlayFromRealValue(hitRecord.lowValue) - CGFloat(UI_IntersetPoint_Radius)/2, CGFloat(UI_IntersetPoint_Radius), CGFloat(UI_IntersetPoint_Radius)))

            
        }
    }
    
    func findIndexGTorEqual(to:Int, dateSet:NSMutableArray, start:Int, end:Int) ->Int{
        let index = findIndexAscSort(to, dateSet: dateSet, start: start, end: end)
        
        if index >= dateSet.count - 1 {
            return dateSet.count - 1
        }
        if index < 0 {
            return 0
        }
        
        return index
    }
    
    func findIndexLTorEqual(to:Int, dateSet:NSMutableArray, start:Int, end:Int) ->Int{
        let index = findIndexAscSort(to, dateSet: dateSet, start: start, end: end)
        
        if index > dateSet.count - 1 {
            return dateSet.count - 1
        }
        if index <= 0 {
            return 0
        }
        if (dateSet[index] as! CVRecord).date == to {
            return index
        }
        return index - 1
    }
    
    // 新元素可能的插入下标位置， 如碰到相等元素，占用相等元素的下标, 可能值 -1 --> length
    func findIndexAscSort(to:Int, dateSet:NSMutableArray, start:Int, end:Int) ->Int {
        assert(start <= end)
        if  start == end {
            if (dateSet[start] as! CVRecord).date < to {
                return start + 1
            } else {
                return start
            }
        }
        let middle = (start + end)/2
        
        if(dateSet[middle] as! CVRecord).date  == to {
            return middle
        }
        
        if middle == start || middle == end {
            if (dateSet[end] as! CVRecord).date == to {
                return end
            } else if (dateSet[start] as! CVRecord).date == to {
                return start
            } else {
                if (dateSet[start] as! CVRecord).date > to {
                    return start
                } else if (dateSet[end] as! CVRecord).date < to{
                    return end + 1
                } else {
                    return end
                }
            }
        } else if (dateSet[middle] as! CVRecord).date > to {
            return findIndexAscSort(to, dateSet: dateSet, start: start, end: middle - 1)
        } else  {
            return findIndexAscSort(to, dateSet: dateSet, start: middle + 1, end: end)
        }
    }

    

    //绘制渐变
    func drawGradientRect() {
        if (pDataDisplayed?.data.count <= 1) {
            return
        }


        let context = UIGraphicsGetCurrentContext()
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let startColor = UI_StartGradient_Color
        let startColorComponents = CGColorGetComponents(startColor.CGColor)
        let endColor = UI_EndGradient_Color
        let endColorComponents = CGColorGetComponents(endColor.CGColor)
        let colorComponents = [startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]]
        let locations:[CGFloat] = [CGFloat(UI_StartGradient_Position), CGFloat(UI_EndGradient_Position)]
        let gradient = CGGradientCreateWithColorComponents(colorSpace, colorComponents, locations, 2)
        CGContextDrawLinearGradient(context, gradient, CGPoint.init(x: self.bounds.width, y: 0), CGPoint.init(x: self.bounds.width, y: self.bounds.height), CGGradientDrawingOptions.init(rawValue: 0))
    }
    
    
    /* ---------------- 用户交互 --------- */
    func handlePinchGesture(sender : UIPinchGestureRecognizer) {
        var centerRealX:Int?
        var centerDisplayX:CGFloat?
        if (sender.state == .Began) {
            p_pinchStartScale = 1
            p_pinchStartX0 = sender.locationOfTouch(0, inView: self).x
            p_pinchStartX1 = sender.locationOfTouch(1, inView: self).x
            return
        }
        centerDisplayX = (p_pinchStartX0 + p_pinchStartX1) / 2.0
        centerRealX = XRealFromDisplayValue(centerDisplayX!)

        let factor = sender.scale - p_pinchStartScale
        let oldScale = scale
        let newScale = scale  + factor / kScaleResistance
        if (newScale > oldScale ) {
            // 屏宽小于15分钟
            if (self.displayLevel == .QuaterHour && realDateInterval() <=  15*60 + 60) {
                return
            // 屏宽小于1小时
            } else if (self.displayLevel == .Hour && realDateInterval() <=  3600) {
                self.displayLevel = .QuaterHour
                self.scale = 1
            // 屏宽小于6小时
            } else if (self.displayLevel == .QuaterDay && realDateInterval() <= 6 * 3600) {
                self.displayLevel = .Hour
                self.scale = 4.0/6
            // 屏宽小于24小时
            } else if (self.displayLevel == .Day && realDateInterval() <= 24 * 3600) {
                self.displayLevel =  .QuaterDay
                self.scale = 1
            // 屏宽小于1周
            } else if (self.displayLevel == .Week && realDateInterval() <= 7 * 24 * 3600) {
                self.displayLevel =  .Day
                self.scale = 4.0/7
            // 屏宽小于1月
            } else if (self.displayLevel == .Month && realDateInterval() <= 28 * 24 * 3600){
                self.displayLevel =  .Week
                self.scale = 1
            // 屏宽小于2月
            }  else if (self.displayLevel == .TwiceMonth && realDateInterval() <= 30 * 24 * 3600 * 2){
                self.displayLevel =  .Month
                self.scale =  2
            // 屏宽小于6月
            }  else if (self.displayLevel == .SixthMonth && realDateInterval() <= 30 * 24 * 3600 * 6){
                self.displayLevel =  .TwiceMonth
                self.scale =  8.0/6
                // 屏宽小于24月
            }  else if (self.displayLevel == .Year && realDateInterval() <= 24 * 3600 * 365 * 2){
                self.displayLevel =  .SixthMonth
                self.scale =  1
            }    else{
                scale = newScale
            }
        } else if (newScale < oldScale) {//&& XDisplayLabelsWidthTotal(newScale) >= self.frame.size.width) {
            // 屏宽 大于 1小时
            if (self.displayLevel == .QuaterHour && realDateInterval() >= 3600 * 1) {
                self.displayLevel = .Hour
                self.scale = 4
                // 屏宽 大于 6小时
            } else if (self.displayLevel == .Hour && realDateInterval() >= 3600 * 6) {
                self.displayLevel = .QuaterDay
                self.scale = 4
                // 屏宽大于 24小时
            } else if (self.displayLevel == .QuaterDay  && realDateInterval() >= 24 * 3600) {
                self.displayLevel =  .Day
                self.scale = 4
                // 屏宽大于 1周
            } else if (self.displayLevel == .Day  && realDateInterval() >= 24 * 3600 * 7) {
                self.displayLevel =  .Week
                self.scale = 4
                // 屏宽大于 30天
            } else if (self.displayLevel == .Week  && realDateInterval() >= 24 * 3600 * 30) {
                self.displayLevel =  .Month
                self.scale = 4
                // 屏宽大于 30 * 4 天
            } else if (self.displayLevel == .Month  && realDateInterval() >= 24 * 3600 * 30 * 4) {
                self.displayLevel =  .TwiceMonth
                self.scale = 2
                // 屏宽大于 30 * 8 天
            } else if (self.displayLevel == .TwiceMonth  && realDateInterval() >= 24 * 3600 * 30 * 8) {
                self.displayLevel =  .SixthMonth
                self.scale = 3
                // 屏宽大于 30 * 12 * 2 天
            } else if (self.displayLevel == .SixthMonth  && realDateInterval() >= 24 * 3600 * 365 * 2) {
                self.displayLevel =  .Year
                self.scale = 3/2.0
            } else if (self.displayLevel == .Year) {
                return
            }else {
                scale = newScale
            }

        } else {
            scale = newScale
        }
        
        // 求解offset使得centerRealX -> CenterDisplayX
        let startXDisplay = kPaddingLeft
        let endXDisplay = self.frame.size.width
        let displayInterval = CGFloat(endXDisplay - startXDisplay)
        offsetX = CGFloat(centerRealX! - realDateStart_once()) * displayInterval / CGFloat(realDateInterval()) + startXDisplay - centerDisplayX!

        p_pinchStartScale = sender.scale
        setNeedsDisplay()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
     
        if (infoView != nil) {
            infoView?.removeFromSuperview()
            p_hitRecordIndex = -1
            paddingTop = 0.0
        }
        p_panStartX = (touches.first?.locationInView(self).x)!
        p_pinchStartScale = 1
        p_pinchStartX0 = 0
        p_pinchStartX1 = 0
    }
    
    func handlePanGesture(sender: UIPanGestureRecognizer) {
        if sender.state == .Began {
            p_panStartX = (sender.locationInView(self)).x
            return
        }
        if (sender.view != self) {
            return
        }

        offsetX += p_panStartX - (sender.locationInView(self)).x
        p_panStartX = (sender.locationInView(self)).x
        
        setNeedsDisplay()
    }
    
    func handleTapGesture(sender:UIPanGestureRecognizer) {
        
        p_hitRecordIndex = -1
        if (dataTotal == nil || dataTotal?.data.count == 0) {
            return
        }
        let realX = XRealFromDisplayValue(sender.locationInView(self).x)
        var index1 = findIndexGTorEqual(realX, dateSet:(dataTotal?.data)! , start: 0, end: (dataTotal?.data.count)! - 1)
        var index2 = findIndexLTorEqual(realX, dateSet:(dataTotal?.data)! , start: 0, end: (dataTotal?.data.count)! - 1)
        if (index1 < 0) {index1 = 0}
        if (index1 >=  dataTotal?.data.count ) {index1 =  (dataTotal?.data.count)!}
        if (index2 < 0) {index2 = 0}
        if (index2 >=  dataTotal?.data.count ) {index2 =  (dataTotal?.data.count)!}
        
        var index = -1
        let displayX1 = XDisPlayFromRealValue(((dataTotal?.data[index1])! as! CVRecord).date)
        let displayX2 = XDisPlayFromRealValue(((dataTotal?.data[index2])! as! CVRecord).date)
        
        let fbs1 = fabs(displayX1 - sender.locationInView(self).x )
        let fbs2 = fabs(displayX2 - sender.locationInView(self).x )
        if (fbs1 < 30 && fbs2 < 30) {
            if (fbs1 < fbs2) {
                index = index1
            } else {
                index = index2
            }
        } else if (fbs1 < 30) {
            index = index1
        } else if (fbs2 < 30) {
            index = index2
        }

        if (index >= 0 && index <  dataTotal?.data.count) {
            let record = dataTotal?.data[index]  as! CVRecord
            p_hitRecordIndex = index
            self.delegate?.CVRecordHit(index)
            infoView = CVInfoView.InfoViewWithMessage( "date:\(record.date), low: \(record.lowValue), high:\(record.highValue)", leading: XDisPlayFromRealValue(record.date))
            infoView?.frame = CGRectMake(0, 0, self.frame.size.width, 60.0)
            self.addSubview(infoView!)
//            paddingTop = 60.0 //客户要求不下移
        }
        setNeedsDisplay()
    }
    
    internal override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if infoView != nil {
            return false
        } else {
            return true
        }
    }
    
    
}
