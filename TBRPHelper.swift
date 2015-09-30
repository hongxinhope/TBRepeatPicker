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
    
    class func sequencesInWeekPicker(language: TBRPLanguage) -> [String] {
        let internationalControl = TBRPInternationalControl(language: language)
        
        return [internationalControl.localized("TBRPHelper.sequencesInWeekPicker.first", comment: "first"), internationalControl.localized("TBRPHelper.sequencesInWeekPicker.second", comment: "second"), internationalControl.localized("TBRPHelper.sequencesInWeekPicker.third", comment: "third"), internationalControl.localized("TBRPHelper.sequencesInWeekPicker.fourth", comment: "fourth"), internationalControl.localized("TBRPHelper.sequencesInWeekPicker.fifth", comment: "fifth"), internationalControl.localized("TBRPHelper.sequencesInWeekPicker.last", comment: "last")]
    }
    
}
