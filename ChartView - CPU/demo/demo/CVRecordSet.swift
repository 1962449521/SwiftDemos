//
//  CharlData.swift
//  demo
//
//  Created by Mitty on 16/1/30.
//  Copyright © 2016年 Mitty. All rights reserved.
//

import UIKit

@objc(CVRecord)
class CVRecord:NSObject {
    var date      : Int   = 0         // 日期 UNIX时间戳
    var lowValue  : Float = 0.0       // 低值
    var highValue : Float = 0.0       // 高值
    var otherInfo : NSObject?         // 其它信息
};

struct CVDate {
    var year:Int   = 0
    var month:Int  = 0
    var day:Int  = 0
    var weekOfMonth:Int = 0
    var week:Int   = 0
    var hour:Int   = 0
    var minute:Int = 0
    var second:Int = 0
}

@objc(CVRecordSet)
class CVRecordSet: NSObject {
    var maxHigh      : Float = 0.0
    var minLow       : Float = 0.0
    var minTS        : Int   = 0
    var maxTS        : Int   = 0

    var data : NSMutableArray = [] {
        didSet {
            if (data.count == 0) {
                return
            }
            
            // 取得纵向区段
            data.sortUsingComparator { (obj1:AnyObject, obj2:AnyObject) -> NSComparisonResult in
                return NSNumber(float: obj1.highValue).compare(NSNumber(float: obj2.highValue))
            }
            maxHigh = (data.lastObject?.highValue)!
            
            data.sortUsingComparator { (obj1:AnyObject, obj2:AnyObject) -> NSComparisonResult in
                return NSNumber(float: obj1.lowValue).compare(NSNumber(float: obj2.lowValue))
            }
            minLow = (data.firstObject?.lowValue)!
            
            // 数据排序
            data.sortUsingComparator { (obj1:AnyObject, obj2:AnyObject) -> NSComparisonResult in
                return NSNumber(integer: (obj1 as! CVRecord).date).compare(NSNumber(integer: (obj2 as! CVRecord).date))
            }
            
            // 获得横向区段
            minTS = (data.firstObject?.date)!
            maxTS = (data.lastObject?.date)!
        }
    }
    
    func initDataWithJsonFile(path : String) {
        let tempData = NSMutableArray()
        let data = NSData(contentsOfURL:  NSURL(fileURLWithPath: path))
        guard let json = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) else {
            return
        }
        for var i = 0; i < json.count; i++ {
            let aCVRecord = CVRecord()
            aCVRecord.date = CVUtil.timeIntervalFromDate(json[i].objectForKey("date") as! NSString)
            aCVRecord.lowValue = json[i].objectForKey("lowValue") as! Float
            aCVRecord.highValue = json[i].objectForKey("highValue") as! Float
            tempData.addObject(aCVRecord)
        }
        self.data = tempData
    }
    
    override func copy() -> AnyObject {
       let copyedItem  = CVRecordSet()
        copyedItem.maxHigh = self.maxHigh
        copyedItem.minLow = self.minLow
        copyedItem.minTS = self.minTS
        copyedItem.maxTS = self.maxTS
        copyedItem.data = self.data
       return copyedItem
    }
}
