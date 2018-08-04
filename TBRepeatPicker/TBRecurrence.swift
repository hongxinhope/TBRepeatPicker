//
//  TBRecurrence.swift
//  TBRepeatPicker
//
//  Created by 洪鑫 on 15/10/7.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import Foundation

@objc enum TBRPFrequency: Int {
    case daily = 0
    case weekly = 1
    case monthly = 2
    case yearly = 3
}

@objc enum TBRPWeekPickerNumber: Int {
    case first = 0
    case second = 1
    case third = 2
    case fourth = 3
    case fifth = 4
    case last = 5
}

@objc enum TBRPWeekPickerDay: Int {
    case sunday = 0
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    case day = 7
    case weekday = 8
    case weekendDay = 9
}

class TBRecurrence: NSObject {
    /** The frequency of recurrence, must be one of the following cases:
    * TBRPFrequency.Daily
    * TBRPFrequency.Weekly
    * TBRPFrequency.Monthly
    * TBRPFrequency.Yearly
    */
    var frequency: TBRPFrequency = .daily
    
    /** The interval between each frequency iteration. For example, when in a daily frequency, an interval of 1 means that event will occur every day, and an interval of 3 means that event will occur every 3 days. The default interval is 1.
    */
    var interval: Int = 1
    
    /** The selected weekdays when frequency is weekly. Elements in this array are all integers in a range between 0 to 6, 0 means Sunday, which is the first day of week, and the integers from 1 to 6 respectively mean the days from Monday to Saturday. This property value is valid only for a frequency type of TBRPFrequency.Weekly.
    */
    var selectedWeekdays = [Int]() {
        didSet {
            selectedWeekdays = selectedWeekdays.sorted { $0 < $1 }
        }
    }
    
    /** A boolean value decides whether the recurrence is constructed by week number or not when frequency is weekly or yearly. For example, we can get a recurrence like "Second Friday" with it. This property value is valid only for a frequency type of TBRPFrequency.Monthly or TBRPFrequency.Yearly.
    */
    var byWeekNumber = false
    
    /** The selected monthdays when frequency is monthly. Elements in this array are all integers in a range between 1 to 31, which respectively mean the days from 1st to 31st of a month. This property value is valid only for a frequency type of TBRPFrequency.Monthly.
    */
    var selectedMonthdays = [Int]() {
        didSet {
            selectedMonthdays = selectedMonthdays.sorted { $0 < $1 }
        }
    }
    
    /** The selected months when frequency is yearly. Elements in this array are all integers in a range between 1 to 12, which respectively mean the months from January to December. This property value is valid only for a frequency type of TBRPFrequency.Yearly.
    */
    var selectedMonths = [Int]() {
        didSet {
            selectedMonths = selectedMonths.sorted { $0 < $1 }
        }
    }
    
    /** The week number when the recurrence is constructed by week number, must be one of the following cases:
    * TBRPWeekPickerNumber.First
    * TBRPWeekPickerNumber.Second
    * TBRPWeekPickerNumber.Third
    * TBRPWeekPickerNumber.Fourth
    * TBRPWeekPickerNumber.Fifth
    * TBRPWeekPickerNumber.Last
    
    This property value is valid only for a frequency type of TBRPFrequency.Monthly or TBRPFrequency.Yearly.
    */
    var pickedWeekNumber: TBRPWeekPickerNumber = .first
    
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
    
    This property value is valid only for a frequency type of TBRPFrequency.Monthly or TBRPFrequency.Yearly.
    */
    var pickedWeekday: TBRPWeekPickerDay = .sunday
    
    // MARK: - Initialization
    convenience init(occurrenceDate: Date) {
        self.init()
        
        let occurrenceDateDayIndexInWeek = Calendar.dayIndexInWeek(occurrenceDate)
        let occurrenceDateDayIndexInMonth = Calendar.dayIndexInMonth(occurrenceDate)
        let occurrenceDateMonthIndexInYear = Calendar.monthIndexInYear(occurrenceDate)
        
        selectedWeekdays = [occurrenceDateDayIndexInWeek - 1]
        selectedMonthdays = [occurrenceDateDayIndexInMonth]
        selectedMonths = [occurrenceDateMonthIndexInYear]
    }
    
    func recurrenceCopy() -> TBRecurrence {
        let recurrence = TBRecurrence()
        
        recurrence.frequency = frequency
        recurrence.interval = interval
        recurrence.selectedWeekdays = selectedWeekdays
        recurrence.byWeekNumber = byWeekNumber
        recurrence.selectedMonthdays = selectedMonthdays
        recurrence.selectedMonths = selectedMonths
        recurrence.pickedWeekNumber = pickedWeekNumber
        recurrence.pickedWeekday = pickedWeekday
        
        return recurrence
    }
    
    class func isEqualRecurrence(_ recurrence1: TBRecurrence?, recurrence2: TBRecurrence?) -> Bool {
        if recurrence1 == nil && recurrence2 == nil {
            return true
        } else if recurrence1?.frequency == recurrence2?.frequency && recurrence1?.interval == recurrence2?.interval {
            if recurrence1?.frequency == .daily {
                return true
            } else if recurrence1?.frequency == .weekly {
                let selectedWeekdays1 = recurrence1?.selectedWeekdays.sorted { $0 < $1 }
                let selectedWeekdays2 = recurrence2?.selectedWeekdays.sorted { $0 < $1 }
                
                return selectedWeekdays1! == selectedWeekdays2!
            } else if recurrence1?.frequency == .monthly {
                if recurrence1?.byWeekNumber == recurrence2?.byWeekNumber {
                    if recurrence1?.byWeekNumber == true {
                        return recurrence1?.pickedWeekNumber == recurrence2?.pickedWeekNumber && recurrence1?.pickedWeekday == recurrence2?.pickedWeekday
                    } else {
                        let selectedMonthdays1 = recurrence1?.selectedMonthdays.sorted { $0 < $1 }
                        let selectedMonthdays2 = recurrence2?.selectedMonthdays.sorted { $0 < $1 }
                        
                        return selectedMonthdays1! == selectedMonthdays2!
                    }
                } else {
                    return false
                }
            } else if recurrence1?.frequency == .yearly {
                if recurrence1?.byWeekNumber == recurrence2?.byWeekNumber {
                    let selectedMonths1 = recurrence1?.selectedMonths.sorted { $0 < $1 }
                    let selectedMonths2 = recurrence2?.selectedMonths.sorted { $0 < $1 }
                    
                    if recurrence1?.byWeekNumber == true {
                        return selectedMonths1! == selectedMonths2! && recurrence1?.pickedWeekNumber == recurrence2?.pickedWeekNumber && recurrence1?.pickedWeekday == recurrence2?.pickedWeekday
                    } else {
                        return selectedMonths1! == selectedMonths2!
                    }
                } else {
                    return false
                }
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    // preset recurrence initialization
    class func dailyRecurrence(_ occurrenceDate: Date) -> TBRecurrence {
        return initDaily(1, occurrenceDate: occurrenceDate)
    }
    
    class func weeklyRecurrence(_ occurrenceDate: Date) -> TBRecurrence {
        return initWeekly(1, selectedWeekdays: [], occurrenceDate: occurrenceDate)
    }
    
    class func biWeeklyRecurrence(_ occurrenceDate: Date) -> TBRecurrence {
        return initWeekly(2, selectedWeekdays: [], occurrenceDate: occurrenceDate)
    }
    
    class func monthlyRecurrence(_ occurrenceDate: Date) -> TBRecurrence {
        return initMonthly(1, selectedMonthdays: [], occurrenceDate: occurrenceDate)
    }
    
    class func yearlyRecurrence(_ occurrenceDate: Date) -> TBRecurrence {
        return initYearly(1, selectedMonths: [], occurrenceDate: occurrenceDate)
    }
    
    class func weekdayRecurrence(_ occurrenceDate: Date) -> TBRecurrence {
        return initWeekly(1, selectedWeekdays: [1, 2, 3, 4, 5], occurrenceDate: occurrenceDate)
    }
    
    // custom recurrence initialization
    class func initDaily(_ interval: Int, occurrenceDate: Date) -> TBRecurrence {
        let dailyRecurrence = TBRecurrence(occurrenceDate: occurrenceDate)
        dailyRecurrence.frequency = .daily
        
        if interval < 1 {
            dailyRecurrence.interval = 1
        } else {
            dailyRecurrence.interval = interval
        }
        
        return dailyRecurrence
    }
    
    class func initWeekly(_ interval: Int, selectedWeekdays: [Int], occurrenceDate: Date) -> TBRecurrence {
        var selectedWeekdays = selectedWeekdays
        let weeklyRecurrence = TBRecurrence(occurrenceDate: occurrenceDate)
        weeklyRecurrence.frequency = .weekly
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
    
    class func initMonthly(_ interval: Int, selectedMonthdays: [Int], occurrenceDate: Date) -> TBRecurrence {
        var selectedMonthdays = selectedMonthdays
        let monthlyRecurrence = TBRecurrence(occurrenceDate: occurrenceDate)
        monthlyRecurrence.frequency = .monthly
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
    
    class func initMonthlyByWeekNumber(_ interval: Int, pickedWeekNumber: TBRPWeekPickerNumber, pickedWeekday: TBRPWeekPickerDay, occurrenceDate: Date) -> TBRecurrence {
        let monthlyRecurrence = TBRecurrence(occurrenceDate: occurrenceDate)
        monthlyRecurrence.frequency = .monthly
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
    
    class func initYearly(_ interval: Int, selectedMonths: [Int], occurrenceDate: Date) -> TBRecurrence {
        var selectedMonths = selectedMonths
        let yearlyRecurrence = TBRecurrence(occurrenceDate: occurrenceDate)
        yearlyRecurrence.frequency = .yearly
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
    
    class func initYearlyByWeekNumber(_ interval: Int, pickedWeekNumber: TBRPWeekPickerNumber, pickedWeekday: TBRPWeekPickerDay, occurrenceDate: Date) -> TBRecurrence {
        let yearlyRecurrence = TBRecurrence(occurrenceDate: occurrenceDate)
        yearlyRecurrence.frequency = .yearly
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
        return frequency == .daily && interval == 1
    }
    
    func isWeeklyRecurrence(_ occurrenceDate: Date) -> Bool {
        let occurrenceDateDayIndexInWeek = Calendar.dayIndexInWeek(occurrenceDate)
        
        return frequency == .weekly && selectedWeekdays == [occurrenceDateDayIndexInWeek - 1] && interval == 1
    }
    
    func isBiWeeklyRecurrence(_ occurrenceDate: Date) -> Bool {
        let occurrenceDateDayIndexInWeek = Calendar.dayIndexInWeek(occurrenceDate)
        
        return frequency == .weekly && selectedWeekdays == [occurrenceDateDayIndexInWeek - 1] && interval == 2
    }
    
    func isMonthlyRecurrence(_ occurrenceDate: Date) -> Bool {
        let occurrenceDateDayIndexInMonth = Calendar.dayIndexInMonth(occurrenceDate)
        
        return frequency == .monthly && interval == 1 && byWeekNumber == false && selectedMonthdays == [occurrenceDateDayIndexInMonth]
    }
    
    func isYearlyRecurrence(_ occurrenceDate: Date) -> Bool {
        let occurrenceDateMonthIndexInYear = Calendar.monthIndexInYear(occurrenceDate)
        
        return frequency == .yearly && interval == 1 && byWeekNumber == false && selectedMonths == [occurrenceDateMonthIndexInYear]
    }
    
    func isWeekdayRecurrence() -> Bool {
        return frequency == .weekly && interval == 1 && selectedWeekdays == [1, 2, 3, 4, 5]
    }
    
    func isCustomRecurrence(_ occurrenceDate: Date) -> Bool {
        return !isDailyRecurrence() && !isWeeklyRecurrence(occurrenceDate) && !isBiWeeklyRecurrence(occurrenceDate) && !isMonthlyRecurrence(occurrenceDate) && !isYearlyRecurrence(occurrenceDate)
    }
}
