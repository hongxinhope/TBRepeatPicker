//
//  TBRPCustomRepeatCell.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/29.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

class TBRPCustomRepeatCell: UITableViewCell {
    // MARK: - View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addDefaultBottomSeparator()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame.origin.x = TBRPHelper.leadingMargin()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetSeparatorWithLeftX(TBRPHelper.leadingMargin())
    }
    
    // MARK: - Separator line
    func removeAllSeparators() {
        for sublayer in layer.sublayers! {
            if sublayer.name == TBRPTopSeparatorIdentifier || sublayer.name == TBRPBottomSeparatorIdentifier {
                sublayer.removeFromSuperlayer()
            }
        }
    }
    
    func removeBottomSeparators() {
        for sublayer in layer.sublayers! {
            if sublayer.name == TBRPBottomSeparatorIdentifier {
                sublayer.removeFromSuperlayer()
            }
        }
    }
    
    func addBottomSeparatorFromLeftX(leftX: CGFloat) {
        for sublayer in layer.sublayers! {
            if sublayer.name == TBRPBottomSeparatorIdentifier {
                sublayer.removeFromSuperlayer()
            }
        }
        
        let bottomSeparator = CALayer()
        bottomSeparator.name = TBRPBottomSeparatorIdentifier
        
        bottomSeparator.frame = CGRectMake(leftX, bounds.size.height - TBRPSeparatorLineWidth, TBRPScreenWidth - leftX, TBRPSeparatorLineWidth)
        bottomSeparator.backgroundColor = TBRPHelper.separatorColor()
        
        layer.addSublayer(bottomSeparator)
    }
    
    func addTopSeparatorFromLeftX(leftX: CGFloat) {
        for sublayer in layer.sublayers! {
            if sublayer.name == TBRPTopSeparatorIdentifier {
                sublayer.removeFromSuperlayer()
            }
        }
        
        let topSeparator = CALayer()
        topSeparator.name = TBRPTopSeparatorIdentifier
        
        topSeparator.frame = CGRectMake(leftX, 0,TBRPScreenWidth - leftX, TBRPSeparatorLineWidth)
        topSeparator.backgroundColor = TBRPHelper.separatorColor()
        
        layer.addSublayer(topSeparator)
    }
    
    func addDefaultBottomSeparator() {
        addBottomSeparatorFromLeftX(TBRPHelper.leadingMargin())
    }
    
    func addSectionTopSeparator() {
        addTopSeparatorFromLeftX(0)
    }
    
    func addSectionBottomSeparator() {
        addBottomSeparatorFromLeftX(0)
    }
    
    func updateBottomSeparatorWithLeftX(leftX: CGFloat) {
        removeBottomSeparators()
        addBottomSeparatorFromLeftX(leftX)
    }
    
    func resetSeparatorWithLeftX(leftX: CGFloat) {
        removeAllSeparators()
        addBottomSeparatorFromLeftX(leftX)
    }
}
