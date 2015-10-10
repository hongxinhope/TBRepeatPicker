//
//  NSCalendar+TBRPAddition.swift
//  TBRepeatPicker
//
//  Created by 洪鑫 on 15/9/27.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import Foundation

extension NSCalendar {
    class func dayIndexInWeek(date: NSDate, locale: NSLocale) -> Int {
        return components(date, locale: locale).weekday
    }
    
    class func dayIndexInMonth(date: NSDate, locale: NSLocale) -> Int {
        return components(date, locale: locale).day
    }
    
    class func monthIndexInYear(date: NSDate, locale: NSLocale) -> Int {
        return components(date, locale: locale).month
    }
    
    private class func components(date: NSDate, locale: NSLocale) -> NSDateComponents {
        let calendar = NSCalendar.currentCalendar()
        calendar.locale = locale
        let components = calendar.components([.Month, .Weekday, .Day], fromDate: date)
        
        return components
    }
}
