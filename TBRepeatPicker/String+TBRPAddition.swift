//
//  String+TBRPAddition.swift
//  TBRepeatPicker
//
//  Created by 洪鑫 on 15/10/8.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import Foundation

extension String {
    mutating func removeSubstring(_ substring: String) {
        self = self.replacingOccurrences(of: substring, with: "", options: NSString.CompareOptions.literal, range: nil)
    }
}
