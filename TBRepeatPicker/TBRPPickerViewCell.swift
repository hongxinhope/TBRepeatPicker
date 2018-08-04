//
//  TBRPPickerViewCell.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/24.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

enum TBRPPickerStyle {
    case frequency
    case interval
    case week
}

let TBRPPickerHeight: CGFloat = 215.0

private let TBRPPickerRowHeight: CGFloat = 40.0
private let TBRPPickerMaxRowCount = 999

protocol TBRPPickerCellDelegate {
    func pickerDidPick(_ pickerView: UIPickerView, pickStyle: TBRPPickerStyle, didSelectRow row: Int, inComponent component: Int)
}

class TBRPPickerViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: - Public properties
    var language: TBRPLanguage = .english
    var pickerStyle: TBRPPickerStyle?
    var delegate: TBRPPickerCellDelegate?
    var unit: String? {
        didSet {
            pickerView?.reloadComponent(1)
        }
    }
    var frequency: TBRPFrequency? {
        didSet {
            pickerView?.selectRow((frequency?.rawValue)!, inComponent: 0, animated: true)
        }
    }
    var interval: Int? {
        didSet {
            pickerView?.selectRow(interval! - 1, inComponent: 0, animated: true)
        }
    }
    var pickedWeekNumber: TBRPWeekPickerNumber? {
        didSet {
            pickerView?.selectRow((pickedWeekNumber?.rawValue)!, inComponent: 0, animated: true)
        }
    }
    var pickedWeekday: TBRPWeekPickerDay? {
        didSet {
            pickerView?.selectRow((pickedWeekday?.rawValue)!, inComponent: 1, animated: true)
        }
    }
    
    // MARK: - Private properties
    fileprivate var pickerView: UIPickerView?
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        removeAllSeparators()
    }

    convenience init(style: UITableViewCellStyle, reuseIdentifier: String?, pickerStyle: TBRPPickerStyle, language: TBRPLanguage) {
        self.init()

        pickerView = UIPickerView.init(frame: CGRect(x: 0, y: 0, width: TBRPScreenWidth, height: TBRPPickerHeight))
        pickerView!.dataSource = self
        pickerView!.delegate = self
        
        self.pickerStyle = pickerStyle
        if pickerStyle == .frequency {
            addDefaultBottomSeparator()
        } else {
            addSectionBottomSeparator()
        }
        
        self.language = language
        contentView.addSubview(pickerView!)
    }
    
    // MARK: - Separator line
    func removeAllSeparators() {
        for sublayer in layer.sublayers! {
            if sublayer.name == TBRPTopSeparatorIdentifier || sublayer.name == TBRPBottomSeparatorIdentifier {
                sublayer.removeFromSuperlayer()
            }
        }
    }
    
    func addBottomSeparatorFromLeftX(_ leftX: CGFloat) {
        let bottomSeparator = CALayer()
        bottomSeparator.name = TBRPBottomSeparatorIdentifier
        
        bottomSeparator.frame = CGRect(x: leftX, y: TBRPPickerHeight - TBRPSeparatorLineWidth, width: TBRPScreenWidth - leftX, height: TBRPSeparatorLineWidth)
        bottomSeparator.backgroundColor = TBRPHelper.separatorColor()
        
        layer.addSublayer(bottomSeparator)
    }
    
    func addDefaultBottomSeparator() {
        addBottomSeparatorFromLeftX(TBRPHelper.leadingMargin())
    }
    
    func addSectionBottomSeparator() {
        addBottomSeparatorFromLeftX(0)
    }
    
    // MARK: - UIPickerView data source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerStyle == .frequency {
            return 1
        } else {
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerStyle == .frequency {
            return 4
        } else if pickerStyle == .interval {
            if component == 0 {
                return TBRPPickerMaxRowCount
            } else {
                return 1
            }
        } else if pickerStyle == .week {
            if component == 0 {
                return TBRPHelper.numbersInWeekPicker(language).count
            } else {
                return TBRPHelper.daysInWeekPicker(language).count
            }
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return TBRPPickerRowHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return TBRPScreenWidth / 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerStyle == .frequency {
            return TBRPHelper.frequencies(language)[row]
        } else if pickerStyle == .interval {
            if component == 0 {
                return "\(row + 1)"
            } else {
                return unit?.lowercased()
            }
        } else if pickerStyle == .week {
            if component == 0 {
                return TBRPHelper.numbersInWeekPicker(language)[row]
            } else {
                return TBRPHelper.daysInWeekPicker(language)[row]
            }
        }
        return nil
    }
    
    // MARK: - UIPickerView delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let _ = delegate {
            delegate!.pickerDidPick(pickerView, pickStyle: pickerStyle!, didSelectRow: row, inComponent: component)
        }
    }
}
