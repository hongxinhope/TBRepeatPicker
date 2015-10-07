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
        return UIColor.init(red: 188.0 / 255.0, green: 186.0 / 255.0, blue: 193.0 / 255.0, alpha: 1.0).CGColor
    }
    
    class func detailTextColor() -> UIColor {
        return UIColor.init(white: 128.0 / 255.0, alpha: 1.0)
    }
    
    class func weekdays(language: TBRPLanguage) -> [String] {
        let languageLocale = NSLocale(localeIdentifier: language.rawValue)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = languageLocale
        return dateFormatter.weekdaySymbols
    }
    
    class func yearMonths(language: TBRPLanguage) -> [String] {
        let languageLocale = NSLocale(localeIdentifier: language.rawValue)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = languageLocale
        return dateFormatter.shortMonthSymbols
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
    
    class func presetRepeat(language: TBRPLanguage) -> [String] {
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
    
    class func recurrenceString(recurrence: TBRecurrence, language: TBRPLanguage, locale: NSLocale) -> String? {
        var unitString: String?
        if recurrence.interval == 1 {
            unitString = units(language)[recurrence.frequency.rawValue]
        } else if recurrence.interval > 1 {
            unitString = " " + "\(recurrence.interval)" + " " + pluralUnits(language)[recurrence.frequency.rawValue]
        }
        if unitString == nil {
            return nil
        }
        
        if recurrence.frequency == .Daily {
            return "事件将每\(unitString!)重复一次。"
        } else if recurrence.frequency == .Weekly {
            let todayIndexInWeek = NSCalendar.dayIndexInWeek(NSDate(), locale: locale)
            if recurrence.selectedWeekdays == [todayIndexInWeek - 1] {
                return "事件将每\(unitString!)重复一次。"
            } else {
                var weekdaysString = "于" + weekdays(language)[recurrence.selectedWeekdays.first!]
                for i in 1..<recurrence.selectedWeekdays.count {
                    var prefixStr: String?
                    if i == recurrence.selectedWeekdays.count - 1 {
                        prefixStr = "和"
                    } else {
                        prefixStr = "、"
                    }
                    
                    weekdaysString += prefixStr! + weekdays(language)[recurrence.selectedWeekdays[i]]
                }
                return "事件将每\(unitString!)\(weekdaysString)重复一次。"
            }
            
        } else if recurrence.frequency == .Monthly {
            if recurrence.byWeekNumber == true {
                if recurrence.interval == 1 {
                    return "事件将于每\(unitString!)的\(numbersInWeekPicker(language)[recurrence.pickedWeekNumber.rawValue])\(daysInWeekPicker(language)[recurrence.pickedWeekday.rawValue])重复一次。"
                } else {
                    return "事件将每\(unitString!)于\(numbersInWeekPicker(language)[recurrence.pickedWeekNumber.rawValue])\(daysInWeekPicker(language)[recurrence.pickedWeekday.rawValue])重复一次。"
                }
            } else {
                let todayIndexInMonth = NSCalendar.dayIndexInMonth(NSDate(), locale: locale)
                if recurrence.selectedMonthdays == [todayIndexInMonth] {
                    return "事件将每\(unitString!)重复一次。"
                } else {
                    var weekdaysString = "于" + "\(recurrence.selectedMonthdays.first!)" + " " + "日"
                    for i in 1..<recurrence.selectedMonthdays.count {
                        weekdaysString += "、" + "\(recurrence.selectedMonthdays[i])" + " " + "日"
                    }
                    return "事件将每\(unitString!)\(weekdaysString)重复一次。"
                }
            }
        } else if recurrence.frequency == .Yearly {
            var pickedWeekdayString: String?
            if recurrence.byWeekNumber == true {
                pickedWeekdayString = "的\(numbersInWeekPicker(language)[recurrence.pickedWeekNumber.rawValue])\(daysInWeekPicker(language)[recurrence.pickedWeekday.rawValue])"
                
                var monthsString = yearMonths(language)[recurrence.selectedMonths.first! - 1]
                for i in 1..<recurrence.selectedMonths.count {
                    monthsString += "、" + yearMonths(language)[recurrence.selectedMonths[i] - 1]
                }
                return "事件将于每\(unitString!)\(monthsString)\(pickedWeekdayString!)重复一次。"
            } else {
                let todayMonthIndex = NSCalendar.monthIndexInYear(NSDate(), locale: locale)
                if recurrence.selectedMonths == [todayMonthIndex] {
                    return "事件将每\(unitString!)重复一次。"
                } else {
                    var monthsString = yearMonths(language)[recurrence.selectedMonths.first! - 1]
                    for i in 1..<recurrence.selectedMonths.count {
                        monthsString += "、" + yearMonths(language)[recurrence.selectedMonths[i] - 1]
                    }
                    return "事件将于每\(unitString!)\(monthsString)重复。"
                }
            }
            
        } else {
            return nil
        }
    }
}
