//
//  TBRPHelper.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/28.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

let TBRPScreenWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
let TBRPScreenHeight: CGFloat = UIScreen.mainScreen().bounds.size.height
let iPhone6PlusScreenWidth: CGFloat = 414.0

let TBRPTopSeparatorIdentifier = "TBRPTopSeparator"
let TBRPBottomSeparatorIdentifier = "TBRPBottomSeparator"
let TBRPSeparatorLineWidth: CGFloat = 0.5

class TBRPHelper {
    class func leadingMargin() -> CGFloat {
        if TBRPScreenWidth == iPhone6PlusScreenWidth {
            return 20.0
        }
        return 15.0
    }
    
    class func separatorColor() -> CGColorRef {
        let defaultSeparatorColor = UITableView().separatorColor
        let red = defaultSeparatorColor?.rgbComponents.red
        let green = defaultSeparatorColor?.rgbComponents.green
        let blue = defaultSeparatorColor?.rgbComponents.blue
        let bit: CGFloat = 255.0
        
        return UIColor.init(red: red! / bit, green: green! / bit, blue: blue! / bit, alpha: 0.7).CGColor
    }
    
    class func detailTextColor() -> UIColor {
        return UIColor.grayColor()
    }
    
    class func weekdays(language: TBRPLanguage) -> [String] {
        let languageLocale = NSLocale(localeIdentifier: TBRPInternationalControl.languageKey(language))
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = languageLocale
        return dateFormatter.weekdaySymbols
    }
    
    class func yearMonths(language: TBRPLanguage) -> [String] {
        let languageLocale = NSLocale(localeIdentifier: TBRPInternationalControl.languageKey(language))
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = languageLocale
        return dateFormatter.shortMonthSymbols
    }
    
    class func completeYearMonths(language: TBRPLanguage) -> [String] {
        let languageLocale = NSLocale(localeIdentifier: TBRPInternationalControl.languageKey(language))
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = languageLocale
        return dateFormatter.monthSymbols
    }
    
    class func englishDayString(day: Int) -> String {
        var suffix = "th"
        let ones = day % 10
        let tens = (day / 10) % 10
        
        if (tens == 1) {
            suffix = "th"
        } else if (ones == 1) {
            suffix = "st"
        } else if (ones == 2) {
            suffix = "nd"
        } else if (ones == 3) {
            suffix = "rd"
        } else {
            suffix = "th"
        }
        
        return "\(day)\(suffix)"
    }
    
    class func frequencies(language: TBRPLanguage) -> [String] {
        let internationalControl = TBRPInternationalControl(language: language)
        
        return [internationalControl.localized("TBRPHelper.frequencies.daily", comment: "Daily"),internationalControl.localized("TBRPHelper.frequencies.weekly", comment: "Weekly"), internationalControl.localized("TBRPHelper.frequencies.monthly", comment: "Monthly"), internationalControl.localized("TBRPHelper.frequencies.yearly", comment: "Yearly")]
    }
    
    class func units(language: TBRPLanguage) -> [String] {
        let internationalControl = TBRPInternationalControl(language: language)
        
        return [internationalControl.localized("TBRPHelper.units.day", comment: "Day"), internationalControl.localized("TBRPHelper.units.week", comment: "Week"), internationalControl.localized("TBRPHelper.units.month", comment: "Month"), internationalControl.localized("TBRPHelper.units.year", comment: "Year")]
    }
    
    class func pluralUnits(language: TBRPLanguage) -> [String] {
        let internationalControl = TBRPInternationalControl(language: language)
        
        return [internationalControl.localized("TBRPHelper.pluralUnits.days", comment: "days"), internationalControl.localized("TBRPHelper.pluralUnits.weeks", comment: "weeks"), internationalControl.localized("TBRPHelper.pluralUnits.months", comment: "months"), internationalControl.localized("TBRPHelper.pluralUnits.years", comment: "years")]
    }
    
    class func presetRepeats(language: TBRPLanguage) -> [String] {
        let internationalControl = TBRPInternationalControl(language: language)
        
        return [internationalControl.localized("TBRPHelper.presetRepeat.never", comment: "Never"), internationalControl.localized("TBRPHelper.presetRepeat.everyDay", comment: "Every Day"), internationalControl.localized("TBRPHelper.presetRepeat.everyWeek", comment: "Every Week"), internationalControl.localized("TBRPHelper.presetRepeat.everyTwoWeeks", comment: "Every 2 Weeks"), internationalControl.localized("TBRPHelper.presetRepeat.everyMonth", comment: "Every Month"), internationalControl.localized("TBRPHelper.presetRepeat.everyYear", comment: "Every Year")]
    }
    
    class func daysInWeekPicker(language: TBRPLanguage) -> [String] {
        let internationalControl = TBRPInternationalControl(language: language)
        let commonWeekdays = weekdays(language)
        let additionDays = [internationalControl.localized("TBRPHelper.daysInWeekPicker.day", comment: "day"), internationalControl.localized("TBRPHelper.daysInWeekPicker.weekday", comment: "weekday"), internationalControl.localized("TBRPHelper.daysInWeekPicker.weekendDay", comment: "weekend day")]
        
        return commonWeekdays + additionDays
    }
    
    class func numbersInWeekPicker(language: TBRPLanguage) -> [String] {
        let internationalControl = TBRPInternationalControl(language: language)
        
        return [internationalControl.localized("TBRPHelper.numbersInWeekPicker.first", comment: "first"), internationalControl.localized("TBRPHelper.numbersInWeekPicker.second", comment: "second"), internationalControl.localized("TBRPHelper.numbersInWeekPicker.third", comment: "third"), internationalControl.localized("TBRPHelper.numbersInWeekPicker.fourth", comment: "fourth"), internationalControl.localized("TBRPHelper.numbersInWeekPicker.fifth", comment: "fifth"), internationalControl.localized("TBRPHelper.numbersInWeekPicker.last", comment: "last")]
    }
    
    class func recurrenceString(recurrence: TBRecurrence, occurrenceDate: NSDate, language: TBRPLanguage) -> String? {
        let internationalControl = TBRPInternationalControl(language: language)
        
        var unitString: String?
        if language == .Korean || language == .Japanese {
            unitString = "\(recurrence.interval)" + pluralUnits(language)[recurrence.frequency.rawValue]
        } else {
            if recurrence.interval == 1 {
                unitString = units(language)[recurrence.frequency.rawValue]
            } else if recurrence.interval > 1 {
                if language == .English {
                    unitString = "\(recurrence.interval)" + " " + pluralUnits(language)[recurrence.frequency.rawValue]
                } else {
                    unitString = "\(recurrence.interval)" + pluralUnits(language)[recurrence.frequency.rawValue]
                }
            }
        }
        
        unitString = unitString?.lowercaseString
        
        if unitString == nil {
            return nil
        }
        
        if recurrence.frequency == .Daily {
            // Daily
            return String(format: internationalControl.localized("RecurrenceString.presetRepeat", comment: "Event will occur every %@."), unitString!)
        } else if recurrence.frequency == .Weekly {
            // Weekly
            let occurrenceDateDayIndexInWeek = NSCalendar.dayIndexInWeek(occurrenceDate)
            
            if recurrence.selectedWeekdays == [occurrenceDateDayIndexInWeek - 1] {
                return String(format: internationalControl.localized("RecurrenceString.presetRepeat", comment: "Event will occur every %@."), unitString!)
            } else if recurrence.isWeekdayRecurrence() {
                return internationalControl.localized("RecurrenceString.weekdayRecurrence", comment: "Event will occur every weekday.")
            } else if recurrence.selectedWeekdays == [0, 1, 2, 3, 4, 5, 6] && recurrence.interval == 1 {
                return recurrenceString(TBRecurrence.dailyRecurrence(occurrenceDate), occurrenceDate: occurrenceDate, language: language)
            } else {
                var weekdaysString: String
                if language == .Korean {
                    weekdaysString = weekdays(language)[recurrence.selectedWeekdays.first!]
                } else {
                    weekdaysString = internationalControl.localized("RecurrenceString.element.on.weekly", comment: "on") + " " + weekdays(language)[recurrence.selectedWeekdays.first!]
                }
                
                for i in 1..<recurrence.selectedWeekdays.count {
                    var prefixStr: String?
                    if i == recurrence.selectedWeekdays.count - 1 {
                        prefixStr = " " + internationalControl.localized("RecurrenceString.element.and", comment: "and")
                    } else {
                        prefixStr = internationalControl.localized("RecurrenceString.element.comma", comment: ",")
                    }
                    
                    weekdaysString += prefixStr! + " " + weekdays(language)[recurrence.selectedWeekdays[i]]
                }
                
                if language != .English && language != .Korean {
                    weekdaysString.removeSubstring(" ")
                }
                
                if language == .Korean {
                    weekdaysString += internationalControl.localized("RecurrenceString.element.on.weekly", comment: "on")
                }
                
                return String(format: internationalControl.localized("RecurrenceString.specifiedDaysOrMonths", comment: "Event will occur every %@ %@"), unitString!, weekdaysString)
            }
            
        } else if recurrence.frequency == .Monthly {
            // Monthly
            if recurrence.byWeekNumber == true {
                var weekNumberString: String
                
                if language == .Korean {
                    weekNumberString = "\(numbersInWeekPicker(language)[recurrence.pickedWeekNumber.rawValue])" + " " + "\(daysInWeekPicker(language)[recurrence.pickedWeekday.rawValue])" + internationalControl.localized("RecurrenceString.element.on.monthly", comment: "on the")
                } else {
                    weekNumberString = internationalControl.localized("RecurrenceString.element.on.monthly", comment: "on the") + " " + "\(numbersInWeekPicker(language)[recurrence.pickedWeekNumber.rawValue])" + " " + "\(daysInWeekPicker(language)[recurrence.pickedWeekday.rawValue])"
                }
                
                if language != .English && language != .Korean {
                    weekNumberString.removeSubstring(" ")
                }
                
                return String(format: internationalControl.localized("RecurrenceString.specifiedDaysOrMonths", comment: "Event will occur every %@ %@"), unitString!, weekNumberString)
            } else {
                let occurrenceDateDayIndexInMonth = NSCalendar.dayIndexInMonth(occurrenceDate)
                
                if recurrence.selectedMonthdays == [occurrenceDateDayIndexInMonth] {
                    return String(format: internationalControl.localized("RecurrenceString.presetRepeat", comment: "Event will occur every %@."), unitString!)
                } else {
                    var monthdaysString: String
                    if language == .English {
                        monthdaysString = internationalControl.localized("RecurrenceString.element.on.monthly", comment: "on the") + " " + englishDayString(recurrence.selectedMonthdays.first!)
                    } else if language == .Korean {
                        monthdaysString = String(format: internationalControl.localized("RecurrenceString.element.day", comment: ""), recurrence.selectedMonthdays.first!)
                    } else {
                        monthdaysString = internationalControl.localized("RecurrenceString.element.on.monthly", comment: "on the") + String(format: internationalControl.localized("RecurrenceString.element.day", comment: ""), recurrence.selectedMonthdays.first!)
                    }
                    
                    for i in 1..<recurrence.selectedMonthdays.count {
                        var prefixStr: String?
                        if i == recurrence.selectedMonthdays.count - 1 {
                            prefixStr = " " + internationalControl.localized("RecurrenceString.element.and", comment: "and")
                        } else {
                            prefixStr = internationalControl.localized("RecurrenceString.element.comma", comment: ",")
                        }
                        
                        if language == .English {
                            monthdaysString += prefixStr! + " " + englishDayString(recurrence.selectedMonthdays[i])
                        } else {
                            monthdaysString += prefixStr! + " " + String(format: internationalControl.localized("RecurrenceString.element.day", comment: ""), recurrence.selectedMonthdays[i])
                        }
                    }
                    
                    if language != .English && language != .Korean {
                        monthdaysString.removeSubstring(" ")
                    } else if language == .Korean {
                        monthdaysString += internationalControl.localized("RecurrenceString.element.on.monthly", comment: "")
                    }
                    
                    return String(format: internationalControl.localized("RecurrenceString.specifiedDaysOrMonths", comment: "Event will occur every %@ %@"), unitString!, monthdaysString)
                }
            }
        } else if recurrence.frequency == .Yearly {
            // Yearly
            if recurrence.byWeekNumber == true {
                var pickedWeekdayString = internationalControl.localized("RecurrenceString.element.on.yearlyWeekString", comment: "on the") + " " + "\(numbersInWeekPicker(language)[recurrence.pickedWeekNumber.rawValue])" + " " + "\(daysInWeekPicker(language)[recurrence.pickedWeekday.rawValue])"
                
                var monthsString: String
                if language == .English {
                    monthsString = internationalControl.localized("RecurrenceString.element.on.yearlyMonths.byWeekNo", comment: "of") + " " + completeYearMonths(language)[recurrence.selectedMonths.first! - 1]
                } else if language == .Korean {
                    monthsString = yearMonths(language)[recurrence.selectedMonths.first! - 1]
                } else {
                    monthsString = internationalControl.localized("RecurrenceString.element.on.yearlyMonths.byWeekNo", comment: "of") + yearMonths(language)[recurrence.selectedMonths.first! - 1]
                }
                
                for i in 1..<recurrence.selectedMonths.count {
                    var prefixStr: String?
                    if i == recurrence.selectedMonths.count - 1 {
                        prefixStr = " " + internationalControl.localized("RecurrenceString.element.and", comment: "and")
                    } else {
                        prefixStr = internationalControl.localized("RecurrenceString.element.comma", comment: ",")
                    }
                    
                    if language == .English {
                        monthsString += prefixStr! + " " + completeYearMonths(language)[recurrence.selectedMonths[i] - 1]
                    } else {
                        monthsString += prefixStr! + " " + yearMonths(language)[recurrence.selectedMonths[i] - 1]
                    }
                }
                
                if language != .English && language != .Korean {
                    pickedWeekdayString.removeSubstring(" ")
                    monthsString.removeSubstring(" ")
                }
                
                if language == .Korean {
                    pickedWeekdayString += internationalControl.localized("RecurrenceString.element.on.yearlyMonths.byWeekNo", comment: "of")
                }
                
                if language == .English {
                    return String(format: internationalControl.localized("RecurrenceString.yearlyByWeekNoString", comment: "Event will occur every %@ %@ %@"), unitString!, pickedWeekdayString, monthsString)
                } else {
                    return String(format: internationalControl.localized("RecurrenceString.yearlyByWeekNoString", comment: "Event will occur every %@ %@ %@"), unitString!, monthsString, pickedWeekdayString)
                }
                
            } else {
                let occurrenceDateMonthIndexInYear = NSCalendar.monthIndexInYear(occurrenceDate)
                
                if recurrence.selectedMonths == [occurrenceDateMonthIndexInYear] {
                    return String(format: internationalControl.localized("RecurrenceString.presetRepeat", comment: "Event will occur every %@."), unitString!)
                } else {
                    var monthsString: String
                    if language == .English {
                        monthsString = internationalControl.localized("RecurrenceString.element.on.yearlyMonths", comment: "in") + " " + completeYearMonths(language)[recurrence.selectedMonths.first! - 1]
                    } else if language == .Korean {
                        monthsString = completeYearMonths(language)[recurrence.selectedMonths.first! - 1]
                    } else {
                        monthsString = internationalControl.localized("RecurrenceString.element.on.yearlyMonths", comment: "in") + yearMonths(language)[recurrence.selectedMonths.first! - 1]
                    }
                    
                    for i in 1..<recurrence.selectedMonths.count {
                        var prefixStr: String?
                        if i == recurrence.selectedMonths.count - 1 {
                            prefixStr = " " + internationalControl.localized("RecurrenceString.element.and", comment: "and")
                        } else {
                            prefixStr = internationalControl.localized("RecurrenceString.element.comma", comment: ",")
                        }
                        
                        if language == .English {
                            monthsString += prefixStr! + " " + completeYearMonths(language)[recurrence.selectedMonths[i] - 1]
                        } else {
                            monthsString += prefixStr! + " " + yearMonths(language)[recurrence.selectedMonths[i] - 1]
                        }
                    }
                    
                    if language != .English && language != .Korean {
                        monthsString.removeSubstring(" ")
                    }
                    
                    if language == .Korean {
                        monthsString += internationalControl.localized("RecurrenceString.element.on.yearlyMonths", comment: "in")
                    }
                    
                    return String(format: internationalControl.localized("RecurrenceString.specifiedDaysOrMonths", comment: "Event will occur every %@ %@"), unitString!, monthsString)
                }
            }
            
        } else {
            return nil
        }
    }
    
}
