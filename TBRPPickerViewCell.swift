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
let daysOfWeekPicker = ["星期日", "星期一", "星期二", "星期三", "星期四","星期五", "星期六", "自然日", "工作日", "周末"]
let sequencesOfWeekPicker = ["第一个", "第二个", "第三个", "第四个", "第五个", "最后"]

private let TBRPPickerRowHeight: CGFloat = 40.0
private let TBRPPickerMaxRowCount = 999

protocol TBRPPickerCellDelegate {
    func pickerDidPick(pickerView: UIPickerView, pickStyle: TBRPPickerStyle, didSelectRow row: Int, inComponent component: Int)
}

class TBRPPickerViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: - Public properties
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
    
    // MARK: - Private properties
    private var pickerView: UIPickerView?
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    convenience init(style: UITableViewCellStyle, reuseIdentifier: String?, pickerStyle: TBRPPickerStyle?) {
        self.init()

        pickerView = UIPickerView.init(frame: CGRectMake(0, 0, TBRPScreenWidth, TBRPPickerHeight))
        pickerView!.dataSource = self
        pickerView!.delegate = self
        
        if let style = pickerStyle {
            self.pickerStyle = style
        }
        contentView.addSubview(pickerView!)
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
                return sequencesOfWeekPicker.count
            } else {
                return daysOfWeekPicker.count
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
            return frequencies[row]
        } else if pickerStyle == .Every {
            if component == 0 {
                return "\(row + 1)"
            } else {
                return unit
            }
        } else if pickerStyle == .Week {
            if component == 0 {
                return sequencesOfWeekPicker[row]
            } else {
                return daysOfWeekPicker[row]
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
