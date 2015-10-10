//
//  TBRPCollectionItem.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/25.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

private let lineWidth: CGFloat = 0.5

class TBRPCollectionItem: UICollectionViewCell {
    // MARK: - Public properties
    var textLabel: UILabel?
    var showTopLine = true
    var showBottomLine = true
    var showLeftLine = true
    var showRightLine = true
    
    // MARK: - Private properties
    private let topLine  = CALayer()
    private let bottomLine  = CALayer()
    private let leftLine  = CALayer()
    private let rightLine  = CALayer()
    
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textLabel = UILabel(frame: CGRectMake(lineWidth, lineWidth, bounds.size.width - 2 * lineWidth, bounds.size.height - 2 * lineWidth))
        textLabel?.textAlignment = .Center
        backgroundView = textLabel
        
        // add separator line
        topLine.frame = CGRectMake(0, 0, bounds.size.width, lineWidth)
        topLine.backgroundColor = separatorColor()
        
        bottomLine.frame = CGRectMake(0, bounds.size.height - lineWidth, bounds.size.width, lineWidth)
        bottomLine.backgroundColor = separatorColor()
        
        leftLine.frame = CGRectMake(0, 0, lineWidth, bounds.size.height)
        leftLine.backgroundColor = separatorColor()
        
        rightLine.frame = CGRectMake(bounds.size.width - lineWidth, 0, lineWidth, bounds.size.height)
        rightLine.backgroundColor = separatorColor()
        
        layer.addSublayer(topLine)
        layer.addSublayer(bottomLine)
        layer.addSublayer(leftLine)
        layer.addSublayer(rightLine)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topLine.hidden = !showTopLine
        bottomLine.hidden = !showBottomLine
        leftLine.hidden = !showLeftLine
        rightLine.hidden = !showRightLine
    }
    
    // MARK: - Helper
    private func separatorColor() -> CGColorRef {
        return UIColor.init(white: 187.0 / 255.0, alpha: 1.0).CGColor
    }
    
    func setItemSelected(selected: Bool) {
        if selected == true {
            textLabel?.backgroundColor = tintColor
        } else {
            textLabel?.backgroundColor = UIColor.whiteColor()
        }
    }
}
