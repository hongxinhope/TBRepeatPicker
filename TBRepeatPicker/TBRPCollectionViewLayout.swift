//
//  TBRPCollectionViewLayout.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/25.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

class TBRPCollectionViewLayout: UICollectionViewFlowLayout {
    private var mode: TBRPCollectionMode?
    
    convenience init(mode: TBRPCollectionMode) {
        self.init()
        
        self.mode = mode
        if mode == .Days {
            itemSize = CGSizeMake(TBRPDaysItemWidth, TBRPDaysItemHeight)
        } else {
            itemSize = CGSizeMake(TBRPMonthsItemWidth, TBRPMonthsItemHeight)
        }
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }

    override func collectionViewContentSize() -> CGSize {
        if mode == .Days {
            return CGSizeMake(TBRPScreenWidth, TBRPDaysCollectionHeight)
        } else {
            return CGSizeMake(TBRPScreenWidth, TBRPMonthsCollectionHeight)
        }
    }
    
}
