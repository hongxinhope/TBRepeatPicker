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
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        calendar?.locale = locale
        let components = calendar?.components(.Weekday, fromDate: date)
        return (components?.weekday)! - 1
    }
}
