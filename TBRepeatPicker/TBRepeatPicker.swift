//
//  TBRepeatPicker.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/23.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

/*
enum TBRPLanguage: String {
    case English = "en"
    case SimplifiedChinese = "zh-Hans"
    case TraditionalChinese = "zh-Hant"
    case Korean = "ko"
    case Japanese = "ja"
}
*/

/*
    To support Objective-C, we have to use integer enum.
*/
@objc enum TBRPLanguage: Int {
    case english = 0
    case simplifiedChinese = 1
    case traditionalChinese = 2
    case korean = 3
    case japanese = 4
}

class TBRepeatPicker: TBRPPresetRepeatController  {
    
    /** Return an initialized repeat picker object.
    
    - Parameter occurrenceDate: The occurrence date of event. For repeat event, it's the occurrence date of this time. This property will be used for creating weekly/bi-weekly/monthly/yearly/custom recurrence, or judging the type of a recurrence.
    - Parameter language: Language of the picker, must be one of the following 5 supported languages:
      * TBRPLanguage.English
      * TBRPLanguage.SimplifiedChinese
      * TBRPLanguage.TraditionalChinese
      * TBRPLanguage.Korean
      * TBRPLanguage.Japanese
    - Parameter tintColor: A tint color which will be used in navigation bar, tableView, and the highlighted items.
    
    - Returns: An initialized repeat picker object.
    */
    class func initPicker(_ occurrenceDate: Date, language: TBRPLanguage, tintColor: UIColor) -> TBRepeatPicker {
        let repeatPicker = TBRepeatPicker.init(style: .grouped)
        
        repeatPicker.occurrenceDate = occurrenceDate
        repeatPicker.language = language
        repeatPicker.tintColor = tintColor
        
        return repeatPicker
    }
}
