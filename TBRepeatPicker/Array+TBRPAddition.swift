//
//  Array+TBRPAddition.swift
//  TBRepeatPicker
//
//  Created by 洪鑫 on 15/10/8.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import Foundation

extension Array where Element : Hashable {
    var unique: [Element] {
        return Array(Set(self))
    }
}
