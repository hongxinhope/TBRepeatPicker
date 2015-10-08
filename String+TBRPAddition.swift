//
//  String+TBRPAddition.swift
//  TBRepeatPicker
//
//  Created by 洪鑫 on 15/10/8.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import Foundation

extension String {
    mutating func removeSubstring(substring: String) {
        self = self.stringByReplacingOccurrencesOfString(substring, withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
}
