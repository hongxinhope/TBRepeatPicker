//
//  NSCalendar+TBRPAddition.swift
//  TBRepeatPicker
//
//  Created by 洪鑫 on 15/9/27.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import Foundation

extension Calendar {
    static func dayIndexInWeek(_ date: Date) -> Int {
        return components(date).weekday!
    }
    
    static func dayIndexInMonth(_ date: Date) -> Int {
        return components(date).day!
    }
    
    static func monthIndexInYear(_ date: Date) -> Int {
        return components(date).month!
    }
    
    fileprivate static func components(_ date: Date) -> DateComponents {
        var calendar = Calendar.current
        calendar.locale = Locale.current
        let components = (calendar as NSCalendar).components([.month, .weekday, .day], from: date)
        
        return components
    }
}
