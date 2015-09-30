//
//  TBRPPickerViewCell.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/24.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

enum TBRPPickerStyle {
    case Frequency
    case Every
    case Week
}

let TBRPPickerHeight: CGFloat = 215.0

private let TBRPPickerRowHeight: CGFloat = 40.0
private let TBRPPickerMaxRowCount = 999

protocol TBRPPickerCellDelegate {
    func pickerDidPick(pickerView: UIPickerView, pickStyle: TBRPPickerStyle, didSelectRow row: Int, inComponent component: Int)
}

class TBRPPickerViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: - Public properties
    var language: TBRPLanguage = .English
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
    var every: Int? {
        didSet {
            pickerView?.selectRow(every! - 1, inComponent: 0, animated: true)
        }
    }
    var pickedWeekSequence: TBRPWeekPickerSequences? {
        didSet {
            pickerView?.selectRow((pickedWeekSequence?.rawValue)!, inComponent: 0, animated: true)
        }
    }
    var pickedDayOfWeek: TBRPWeekPickerDays? {
        didSet {
            pickerView?.selectRow((pickedDayOfWeek?.rawValue)!, inComponent: 1, animated: true)
        }
    }
    
    // MARK: - Private properties
    private var pickerView: UIPickerView?
    
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

        pickerView = UIPickerView.init(frame: CGRectMake(0, 0, TBRPScreenWidth, TBRPPickerHeight))
        pickerView!.dataSource = self
        pickerView!.delegate = self
        
        self.pickerStyle = pickerStyle
        if pickerStyle == .Frequency {
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
    
    func addBottomSeparatorFromLeftX(leftX: CGFloat) {
        let bottomSeparator = CALayer()
        bottomSeparator.name = TBRPBottomSeparatorIdentifier
        
        bottomSeparator.frame = CGRectMake(leftX, TBRPPickerHeight - TBRPSeparatorLineWidth, TBRPScreenWidth - leftX, TBRPSeparatorLineWidth)
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
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if pickerStyle == .Frequency {
            return 1
        } else {
            return 2
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerStyle == .Frequency {
            return 4
        } else if pickerStyle == .Every {
            if component == 0 {
                return TBRPPickerMaxRowCount
            } else {
                return 1
            }
        } else if pickerStyle == .Week {
            if component == 0 {
                return TBRPHelper.sequencesInWeekPicker(language).count
            } else {
                return TBRPHelper.daysInWeekPicker(language).count
            }
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return TBRPPickerRowHeight
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return TBRPScreenWidth / 2
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerStyle == .Frequency {
            return TBRPHelper.frequencies(language)[row]
        } else if pickerStyle == .Every {
            if component == 0 {
                return "\(row + 1)"
            } else {
                return unit
            }
        } else if pickerStyle == .Week {
            if component == 0 {
                return TBRPHelper.sequencesInWeekPicker(language)[row]
            } else {
                return TBRPHelper.daysInWeekPicker(language)[row]
            }
        }
        return nil
    }
    
    // MARK: - UIPickerView delegate
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let _ = delegate {
            delegate!.pickerDidPick(pickerView, pickStyle: pickerStyle!, didSelectRow: row, inComponent: component)
        }
    }
}
