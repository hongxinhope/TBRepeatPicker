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
    case English = 0
    case SimplifiedChinese = 1
    case TraditionalChinese = 2
    case Korean = 3
    case Japanese = 4
}

class TBRepeatPicker: TBRPPresetRepeatController  {
    
    /** Return an initialized repeat picker object.
    
    - Parameter locale: The locale of picker, it can be the current locale most of the time.
    - Parameter language: The language of picker, must be one of the following 5 supported languages:
      * TBRPLanguage.English
      * TBRPLanguage.SimplifiedChinese
      * TBRPLanguage.TraditionalChinese
      * TBRPLanguage.Korean
      * TBRPLanguage.Japanese
    - Parameter tintColor: A tint color which will be used in navigation bar, tableView, and the highlighted items.
    
    - Returns: An initialized repeat picker object.
    */
    class func initPicker(locale: NSLocale, language: TBRPLanguage, tintColor: UIColor) -> TBRepeatPicker {
        let repeatPicker = TBRepeatPicker.init(style: .Grouped)
        
        repeatPicker.locale = locale
        repeatPicker.language = language
        repeatPicker.tintColor = tintColor
        
        return repeatPicker
    }
}
