//
//  TBRPSwitchCell.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/25.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

private let SwitchTrailingSpace: CGFloat = 15.0

protocol TBRPSwitchCellDelegate {
    func didSwitch(_ sender: AnyObject)
}

class TBRPSwitchCell: TBRPCustomRepeatCell {
    var weekSwitch: UISwitch?
    var delegate: TBRPSwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        weekSwitch = UISwitch()
        weekSwitch?.frame.origin.x = TBRPScreenWidth - (weekSwitch?.bounds.size.width)! - SwitchTrailingSpace
        weekSwitch?.frame.origin.y = contentView.bounds.size.height / 2 - (weekSwitch?.bounds.size.height)! / 2
        weekSwitch?.addTarget(self, action: #selector(TBRPSwitchCell.switchAction(_:)), for: .valueChanged)
        contentView.addSubview(weekSwitch!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func switchAction(_ sender: AnyObject) {
        if let _ = delegate {
            delegate?.didSwitch(sender)
        }
    }

}
