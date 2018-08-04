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
    fileprivate let topLine  = CALayer()
    fileprivate let bottomLine  = CALayer()
    fileprivate let leftLine  = CALayer()
    fileprivate let rightLine  = CALayer()
    
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textLabel = UILabel(frame: CGRect(x: lineWidth, y: lineWidth, width: bounds.size.width - 2 * lineWidth, height: bounds.size.height - 2 * lineWidth))
        textLabel?.textAlignment = .center
        backgroundView = textLabel
        
        // add separator line
        topLine.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: lineWidth)
        topLine.backgroundColor = separatorColor()
        
        bottomLine.frame = CGRect(x: 0, y: bounds.size.height - lineWidth, width: bounds.size.width, height: lineWidth)
        bottomLine.backgroundColor = separatorColor()
        
        leftLine.frame = CGRect(x: 0, y: 0, width: lineWidth, height: bounds.size.height)
        leftLine.backgroundColor = separatorColor()
        
        rightLine.frame = CGRect(x: bounds.size.width - lineWidth, y: 0, width: lineWidth, height: bounds.size.height)
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
        
        topLine.isHidden = !showTopLine
        bottomLine.isHidden = !showBottomLine
        leftLine.isHidden = !showLeftLine
        rightLine.isHidden = !showRightLine
    }
    
    // MARK: - Helper
    fileprivate func separatorColor() -> CGColor {
        return UIColor.init(white: 187.0 / 255.0, alpha: 1.0).cgColor
    }
    
    func setItemSelected(_ selected: Bool) {
        if selected == true {
            textLabel?.backgroundColor = tintColor
            textLabel?.textColor = UIColor.white
        } else {
            textLabel?.backgroundColor = UIColor.white
            textLabel?.textColor = UIColor.black
        }
    }
}
