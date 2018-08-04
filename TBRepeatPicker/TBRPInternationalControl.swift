//
//  TBRPInternationalControl.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/30.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import Foundation

class TBRPInternationalControl: NSObject {
    var language: TBRPLanguage = .english
    
    convenience init(language: TBRPLanguage!) {
        self.init()
        
        self.language = language
    }
    
    fileprivate func localizedForKey(_ key: String!) -> String? {
        let path = Bundle.main.path(forResource: TBRPInternationalControl.languageKey(language), ofType: "lproj")
        if let _ = path {
            let bundle = Bundle(path: path!)
            return bundle!.localizedString(forKey: key, value: nil, table: "TBRPLocalizable")
        } else {
            return nil
        }
    }
    
    func localized(_ key: String!, comment: String!) -> String {
        if let localizedString = localizedForKey(key) as String? {
            if localizedString == key {
                return comment
            }
            return localizedString
        }
        return comment
    }
    
    class func languageKey(_ language: TBRPLanguage) -> String {
        let languageKeys = ["en", "zh-Hans", "zh-Hant", "ko", "ja"]
        
        return languageKeys[language.rawValue]
    }
}
