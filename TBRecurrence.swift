//
//  TBRecurrence.swift
//  TBRepeatPicker
//
//  Created by 洪鑫 on 15/10/7.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import Foundation

enum TBRPFrequency: Int {
    case Daily = 0
    case Weekly = 1
    case Monthly = 2
    case Yearly = 3
}

enum TBRPWeekPickerNumber: Int {
    case First = 0
    case Second = 1
    case Third = 2
    case Fourth = 3
    case Fifth = 4
    case Last = 5
}

enum TBRPWeekPickerDay: Int {
    case Sunday = 0
    case Monday = 1
    case Tuesday = 2
    case Wednesday = 3
    case Thursday = 4
    case Friday = 5
    case Saturday = 6
    case Day = 7
    case Weekday = 8
    case WeekendDay = 9
}

class TBRecurrence: NSObject {
    var frequency: TBRPFrequency = .Daily
    var interval: Int = 1
    
    var selectedWeekdays = [Int]()
    
    var byWeekNumber = false
    var selectedMonthdays = [Int]()
    var selectedMonths = [Int]()
    var pickedWeekNumber: TBRPWeekPickerNumber = .First
    var pickedWeekday: TBRPWeekPickerDay = .Sunday
    
    convenience init(locale: NSLocale) {
        self.init()
        
        let todayIndexInWeek = NSCalendar.dayIndexInWeek(NSDate(), locale: locale)
        let todayIndexInMonth = NSCalendar.dayIndexInMonth(NSDate(), locale: locale)
        let todayMonthIndex = NSCalendar.monthIndexInYear(NSDate(), locale: locale)
        
        selectedWeekdays = [todayIndexInWeek - 1]
        selectedMonthdays = [todayIndexInMonth]
        selectedMonths = [todayMonthIndex]
    }
    
    class func initDaily(interval: Int, locale: NSLocale) -> TBRecurrence {
        let dailyRecurrence = TBRecurrence(locale: locale)
        dailyRecurrence.frequency = .Daily
        
        if interval < 1 {
            dailyRecurrence.interval = 1
        } else {
            dailyRecurrence.interval = interval
        }
        
        return dailyRecurrence
    }
    
    class func initWeekly(interval: Int, var selectedWeekdays: [Int], locale: NSLocale) -> TBRecurrence {
        let weeklyRecurrence = TBRecurrence(locale: locale)
        weeklyRecurrence.frequency = .Weekly
        for day in selectedWeekdays {
            if day < 0 || day > 6 {
                selectedWeekdays.removeObject(day)
            }
        }
        selectedWeekdays = selectedWeekdays.unique
        
        if interval < 1 {
            weeklyRecurrence.interval = 1
        } else {
            weeklyRecurrence.interval = interval
        }
        
        if selectedWeekdays.count > 0 {
            weeklyRecurrence.selectedWeekdays = selectedWeekdays
        }
        
        return weeklyRecurrence
    }
    
    class func initMonthly(interval: Int, var selectedMonthdays: [Int], locale: NSLocale) -> TBRecurrence {
        let monthlyRecurrence = TBRecurrence(locale: locale)
        monthlyRecurrence.frequency = .Monthly
        monthlyRecurrence.byWeekNumber = false
        for day in selectedMonthdays {
            if day < 1 || day > 31 {
                selectedMonthdays.removeObject(day)
            }
        }
        selectedMonthdays = selectedMonthdays.unique
        
        if interval < 1 {
            monthlyRecurrence.interval = 1
        } else {
            monthlyRecurrence.interval = interval
        }
        
        if selectedMonthdays.count > 0 {
            monthlyRecurrence.selectedMonthdays = selectedMonthdays
        }
        
        return monthlyRecurrence
    }
    
    class func initMonthlyByWeekNumber(interval: Int, pickedWeekNumber: TBRPWeekPickerNumber, pickedWeekday: TBRPWeekPickerDay, locale: NSLocale) -> TBRecurrence {
        let monthlyRecurrence = TBRecurrence(locale: locale)
        monthlyRecurrence.frequency = .Monthly
        monthlyRecurrence.byWeekNumber = true
        
        if interval < 1 {
            monthlyRecurrence.interval = 1
        } else {
            monthlyRecurrence.interval = interval
        }
        
        monthlyRecurrence.pickedWeekNumber = pickedWeekNumber
        monthlyRecurrence.pickedWeekday = pickedWeekday
        
        return monthlyRecurrence
    }
    
    class func initYearly(interval: Int, var selectedMonths: [Int], locale: NSLocale) -> TBRecurrence {
        let yearlyRecurrence = TBRecurrence(locale: locale)
        yearlyRecurrence.frequency = .Yearly
        yearlyRecurrence.byWeekNumber = false
        for day in selectedMonths {
            if day < 1 || day > 12 {
                selectedMonths.removeObject(day)
            }
        }
        selectedMonths = selectedMonths.unique
        
        if interval < 1 {
            yearlyRecurrence.interval = 1
        } else {
            yearlyRecurrence.interval = interval
        }
        
        if selectedMonths.count > 0 {
            yearlyRecurrence.selectedMonths = selectedMonths
        }
        
        return yearlyRecurrence
    }
    
    class func initYearlyByWeekNumber(interval: Int, pickedWeekNumber: TBRPWeekPickerNumber, pickedWeekday: TBRPWeekPickerDay, locale: NSLocale) -> TBRecurrence {
        let yearlyRecurrence = TBRecurrence(locale: locale)
        yearlyRecurrence.frequency = .Yearly
        yearlyRecurrence.byWeekNumber = true
        
        if interval < 1 {
            yearlyRecurrence.interval = 1
        } else {
            yearlyRecurrence.interval = interval
        }
        
        yearlyRecurrence.pickedWeekNumber = pickedWeekNumber
        yearlyRecurrence.pickedWeekday = pickedWeekday
        
        return yearlyRecurrence
    }
}
