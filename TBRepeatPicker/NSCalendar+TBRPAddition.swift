//
//  NSCalendar+TBRPAddition.swift
//  TBRepeatPicker
//
//  Created by 洪鑫 on 15/9/27.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import Foundation

extension NSCalendar {
    class func dayIndexInWeek(date: NSDate) -> Int {
        return components(date).weekday
    }
    
    class func dayIndexInMonth(date: NSDate) -> Int {
        return components(date).day
    }
    
    class func monthIndexInYear(date: NSDate) -> Int {
        return components(date).month
    }
    
    private class func components(date: NSDate) -> NSDateComponents {
        let calendar = NSCalendar.currentCalendar()
        calendar.locale = NSLocale.currentLocale()
        let components = calendar.components([.Month, .Weekday, .Day], fromDate: date)
        
        return components
    }
}
