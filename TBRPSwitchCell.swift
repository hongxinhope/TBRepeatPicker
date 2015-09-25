//
//  TBRPSwitchCell.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/25.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

private let SwitchTrailingSpace: CGFloat = 15.0

class TBRPSwitchCell: UITableViewCell {
    var weekSwitch: UISwitch?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        weekSwitch = UISwitch()
        weekSwitch?.frame.origin.x = TBRPScreenWidth - (weekSwitch?.bounds.size.width)! - SwitchTrailingSpace
        weekSwitch?.frame.origin.y = contentView.bounds.size.height / 2 - (weekSwitch?.bounds.size.height)! / 2
        contentView.addSubview(weekSwitch!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
