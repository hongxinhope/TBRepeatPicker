//
//  TBRPCollectionItem.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/25.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

class TBRPCollectionItem: UICollectionViewCell {
    var textLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textLabel = UILabel()
        textLabel?.backgroundColor = UIColor.clearColor()
        backgroundView = textLabel
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
