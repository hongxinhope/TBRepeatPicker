//
//  TBRPCollectionViewLayout.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/25.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

class TBRPCollectionViewLayout: UICollectionViewLayout {
    private var mode: TBRPCollectionMode?
    
    convenience init(mode: TBRPCollectionMode) {
        self.init()
        
        self.mode = mode
    }

    override func collectionViewContentSize() -> CGSize {
        if mode == .Days {
            return CGSizeMake(TBRPDaysItemWidth, TBRPDaysItemHeight)
        } else {
            return CGSizeMake(TBRPMonthsItemWidth, TBRPMonthsItemHeight)
        }
    }
    
}
