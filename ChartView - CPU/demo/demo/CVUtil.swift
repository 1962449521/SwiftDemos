//
//  CVUtil.swift
//  demo
//
//  Created by Mitty on 16/1/30.
//  Copyright © 2016年 Mitty. All rights reserved.
//

import Foundation


class CVUtil {

    static func timeIntervalFromDate(date : NSString) ->Int {
        let d = NSDateFormatter()
        d.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dd = d.dateFromString(date as String)
        return Int(dd!.timeIntervalSince1970)
    }
    
    static func CVDateFromTimeInterval(ts:Int) ->CVDate {
        let date = NSDate(timeIntervalSince1970:NSString(format: "%d",ts).doubleValue)
        let calendar = NSCalendar.currentCalendar()
        let components:NSDateComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second, .Weekday, .WeekOfMonth], fromDate: date)
        let weekArray = [0,7,1,2,3,4,5,6]
        let cvDate = CVDate(year: components.year,
                            month: components.month,
                            day: components.day,
                            weekOfMonth: components.weekOfMonth,
                            week: weekArray[components.weekday],
                            hour: components.hour,
                            minute: components.minute,
                            second: components.second)
        return cvDate
    }
    
    static func nearestHourFrom(ts:Int, isForward:Bool) ->Int {
        var cvDate = CVDateFromTimeInterval(ts)
        var ts2 = ts
        if isForward && (cvDate.minute > 0 || cvDate.second > 0) {
            ts2 += 3600
            cvDate = CVDateFromTimeInterval(ts2)
        }
        let dateStr = NSString(format: "%d-%d-%d %d:0:0", cvDate.year, cvDate.month, cvDate.day, cvDate.hour)
        return timeIntervalFromDate(dateStr)
    }
    
    static func nearestDayFrom(ts:Int, isForward:Bool) ->Int {
        var cvDate = CVDateFromTimeInterval(ts)
        var ts2 = ts
        if isForward && (cvDate.hour > 0 || cvDate.minute > 0 || cvDate.second > 0) {
            ts2 += 24 * 3600
            cvDate = CVDateFromTimeInterval(ts2)
        }
        let dateStr = NSString(format: "%d-%d-%d 0:0:0", cvDate.year, cvDate.month, cvDate.day)
        return timeIntervalFromDate(dateStr)
    }
    
    static func nearestWeekFrom(ts:Int, isForward:Bool) ->Int {
        var cvDate = CVDateFromTimeInterval(ts)
        var ts2 = ts

        if isForward && (cvDate.minute > 0 || cvDate.second > 0 || cvDate.week != 1) {
            let deltaArray = [0,7,6,5,4,3,2,1]
            ts2 += 24 * 3600 * deltaArray[cvDate.week]
            cvDate = CVDateFromTimeInterval(ts2)
        } else {
            let deltaArray = [0,0,1,2,3,4,5,6]
            ts2 -= 24 * 3600 * deltaArray[cvDate.week]
            cvDate = CVDateFromTimeInterval(ts2)
        }
        let dateStr = NSString(format: "%d-%d-%d 0:0:0", cvDate.year, cvDate.month, cvDate.day)
        return timeIntervalFromDate(dateStr)
    }
    
    static func nearestMonthFrom(ts:Int, isForward:Bool) ->Int {
        var cvDate = CVDateFromTimeInterval(ts)
        if isForward && (cvDate.hour > 0 || cvDate.minute > 0 || cvDate.second > 0 || cvDate.day != 1) {
            let month = cvDate.month + 1
            if (month > 12) {
                cvDate.year += 1
                cvDate.month = 1
            } else {
                cvDate.month = month
            }
        }
        let dateStr = NSString(format: "%d-%d-1 0:0:0", cvDate.year, cvDate.month)
        return timeIntervalFromDate(dateStr)
    }
    static func nearestYearFrom(ts:Int, isForward:Bool) ->Int {
        var cvDate = CVDateFromTimeInterval(ts)
        if isForward && (cvDate.hour > 0 || cvDate.minute > 0 || cvDate.second > 0 || cvDate.day != 1 || cvDate.year != 1) {
            cvDate.year += 1
        }
        let dateStr = NSString(format: "%d-1-1 0:0:0", cvDate.year)
        return timeIntervalFromDate(dateStr)
    }
    
}
