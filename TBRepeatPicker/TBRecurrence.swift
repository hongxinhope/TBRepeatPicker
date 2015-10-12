//
//  TBRecurrence.swift
//  TBRepeatPicker
//
//  Created by 洪鑫 on 15/10/7.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import Foundation

@objc enum TBRPFrequency: Int {
    case Daily = 0
    case Weekly = 1
    case Monthly = 2
    case Yearly = 3
}

@objc enum TBRPWeekPickerNumber: Int {
    case First = 0
    case Second = 1
    case Third = 2
    case Fourth = 3
    case Fifth = 4
    case Last = 5
}

@objc enum TBRPWeekPickerDay: Int {
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
    /** The frequency of recurrence, must be one of the following cases:
    * TBRPFrequency.Daily
    * TBRPFrequency.Weekly
    * TBRPFrequency.Monthly
    * TBRPFrequency.Yearly
    */
    var frequency: TBRPFrequency = .Daily
    
    /** The interval between each frequency iteration. For example, when in a daily frequency, an interval of 1 means that event will occur every day, and an interval of 3 means that event will occur every 3 days. The default interval is 1.
    */
    var interval: Int = 1
    
    /** The selected weekdays when frequency is weekly. Elements in this array are all integers in a range between 0 to 6, 0 means Sunday, which is the first day of week, and the integers from 1 to 6 respectively mean the days from Monday to Saturday.
    */
    var selectedWeekdays = [Int]() {
        didSet {
            selectedWeekdays = selectedWeekdays.sort { $0 < $1 }
        }
    }
    
    /** A boolean value decides whether the recurrence is constructed by week number or not when frequency is weekly or yearly. For example, we can get a recurrence like "Second Friday" with it.
    */
    var byWeekNumber = false
    
    /** The selected monthdays when frequency is monthly. Elements in this array are all integers in a range between 1 to 31, which respectively mean the days from 1st to 31st of a month.
    */
    var selectedMonthdays = [Int]() {
        didSet {
            selectedMonthdays = selectedMonthdays.sort { $0 < $1 }
        }
    }
    
    /** The selected months when frequency is yearly. Elements in this array are all integers in a range between 1 to 12, which respectively mean the months from January to December.
    */
    var selectedMonths = [Int]() {
        didSet {
            selectedMonths = selectedMonths.sort { $0 < $1 }
        }
    }
    
    /** The week number when the recurrence is constructed by week number, must be one of the following cases:
    * TBRPWeekPickerNumber.First
    * TBRPWeekPickerNumber.Second
    * TBRPWeekPickerNumber.Third
    * TBRPWeekPickerNumber.Fourth
    * TBRPWeekPickerNumber.Fifth
    * TBRPWeekPickerNumber.Last
    */
    var pickedWeekNumber: TBRPWeekPickerNumber = .First
    
    /** The day of week when the recurrence is constructed by week number, must be one of the following cases:
    * TBRPWeekPickerDay.Sunday
    * TBRPWeekPickerDay.Monday
    * TBRPWeekPickerDay.Tuesday
    * TBRPWeekPickerDay.Wednesday
    * TBRPWeekPickerDay.Thursday
    * TBRPWeekPickerDay.Friday
    * TBRPWeekPickerDay.Saturday
    * TBRPWeekPickerDay.Day
    * TBRPWeekPickerDay.Weekday
    * TBRPWeekPickerDay.WeekendDay
    */
    var pickedWeekday: TBRPWeekPickerDay = .Sunday
    
    // MARK: - Initialization
    convenience init(locale: NSLocale) {
        self.init()
        
        let todayIndexInWeek = NSCalendar.dayIndexInWeek(NSDate(), locale: locale)
        let todayIndexInMonth = NSCalendar.dayIndexInMonth(NSDate(), locale: locale)
        let todayMonthIndex = NSCalendar.monthIndexInYear(NSDate(), locale: locale)
        
        selectedWeekdays = [todayIndexInWeek - 1]
        selectedMonthdays = [todayIndexInMonth]
        selectedMonths = [todayMonthIndex]
    }
    
    // preset recurrence initialization
    class func dailyRecurrence(locale: NSLocale) -> TBRecurrence {
        return initDaily(1, locale: locale)
    }
    
    class func weeklyRecurrence(locale: NSLocale) -> TBRecurrence {
        return initWeekly(1, selectedWeekdays: [], locale: locale)
    }
    
    class func biWeeklyRecurrence(locale: NSLocale) -> TBRecurrence {
        return initWeekly(2, selectedWeekdays: [], locale: locale)
    }
    
    class func monthlyRecurrence(locale: NSLocale) -> TBRecurrence {
        return initMonthly(1, selectedMonthdays: [], locale: locale)
    }
    
    class func yearlyRecurrence(locale: NSLocale) -> TBRecurrence {
        return initYearly(1, selectedMonths: [], locale: locale)
    }
    
    class func weekdayRecurrence(locale: NSLocale) -> TBRecurrence {
        return initWeekly(1, selectedWeekdays: [1, 2, 3, 4, 5], locale: locale)
    }
    
    // custom recurrence initialization
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
    
    // MARK: - Helper
    func isDailyRecurrence() -> Bool {
        return frequency == .Daily && interval == 1
    }
    
    func isWeeklyRecurrence(locale: NSLocale) -> Bool {
        let todayIndexInWeek = NSCalendar.dayIndexInWeek(NSDate(), locale: locale)
        
        return frequency == .Weekly && selectedWeekdays == [todayIndexInWeek - 1] && interval == 1
    }
    
    func isBiWeeklyRecurrence(locale: NSLocale) -> Bool {
        let todayIndexInWeek = NSCalendar.dayIndexInWeek(NSDate(), locale: locale)
        
        return frequency == .Weekly && selectedWeekdays == [todayIndexInWeek - 1] && interval == 2
    }
    
    func isMonthlyRecurrence(locale: NSLocale) -> Bool {
        let todayIndexInMonth = NSCalendar.dayIndexInMonth(NSDate(), locale: locale)
        
        return frequency == .Monthly && interval == 1 && byWeekNumber == false && selectedMonthdays == [todayIndexInMonth]
    }
    
    func isYearlyRecurrence(locale: NSLocale) -> Bool {
        let todayMonthIndex = NSCalendar.monthIndexInYear(NSDate(), locale: locale)
        
        return frequency == .Yearly && interval == 1 && byWeekNumber == false && selectedMonths == [todayMonthIndex]
    }
    
    func isWeekdayRecurrence() -> Bool {
        return frequency == .Weekly && interval == 1 && selectedWeekdays == [1, 2, 3, 4, 5]
    }
    
    func isCustomRecurrence(locale: NSLocale) -> Bool {
        return !isDailyRecurrence() && !isWeeklyRecurrence(locale) && !isBiWeeklyRecurrence(locale) && !isMonthlyRecurrence(locale) && !isYearlyRecurrence(locale)
    }
}
