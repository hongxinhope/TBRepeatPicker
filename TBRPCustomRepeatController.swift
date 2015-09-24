//
//  TBRPCustomRepeatController.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/23.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

enum TBRPFrequency: Int {
    case Daily = 0
    case Weekly = 1
    case Monthly = 2
    case Yearly = 3
}

let frequencies = ["每天", "每周", "每月", "每年"]
let units = ["天", "周", "月", "年"]
let pluralUnits = ["天s", "周s", "月s", "年s"]
let TBRPPickerHeight: CGFloat = 215.0
let TBRPScreenWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
let TBRPScreenHeight: CGFloat = UIScreen.mainScreen().bounds.size.height

private let TBRPCustomRepeatCellID = "TBRPCustomRepeatCell"
private let TBRPPickerViewCellID = "TBRPPickerViewCell"

class TBRPCustomRepeatController: UITableViewController, TBRPPickerCellDelegate {
    // MARK: - Public properties
    var tintColor: UIColor?
    var locale = NSLocale.currentLocale()
    var frequency: TBRPFrequency? {
        didSet {
            updateFrequencyTitleCell()
            updateEveryTitleCell()
            updateFooterTitle()
        }
    }
    var every: Int? {
        didSet {
            updateEveryTitleCell()
            updateFooterTitle()
        }
    }
    
    // MARK: - Private properties
    private let frequencyTitleIndexpath = NSIndexPath(forRow: 0, inSection: 0)
    private var everyTitleIndexpath: NSIndexPath? {
        get {
            if hasPicker() && pickerIndexPath == NSIndexPath(forRow: 1, inSection: 0) {
                return NSIndexPath(forRow: 2, inSection: 0)
            } else {
                return NSIndexPath(forRow: 1, inSection: 0)
            }
        }
    }
    private var frequencyTitleCell: UITableViewCell? {
        get {
            return tableView.cellForRowAtIndexPath(frequencyTitleIndexpath)
        }
    }
    private var everyTitleCell: UITableViewCell? {
        get {
            return tableView.cellForRowAtIndexPath(everyTitleIndexpath!)
        }
    }
    private var pickerIndexPath: NSIndexPath?
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "自定义";
    }
    
    // MARK: - Helper
    func hasPicker() -> Bool {
        return pickerIndexPath != nil
    }
    
    func isPickerCell(indexPath: NSIndexPath) -> Bool {
        return hasPicker() && pickerIndexPath == indexPath
    }
    
    func updateFrequencyTitleCell() {
        frequencyTitleCell?.detailTextLabel?.text = frequencies[(frequency?.rawValue)!]
    }
    
    func updateEveryTitleCell() {
        everyTitleCell?.detailTextLabel?.text = unitString()
        
        if hasPicker() && pickerIndexPath == NSIndexPath(forRow: 2, inSection: 0) {
            let cell = tableView.cellForRowAtIndexPath(pickerIndexPath!) as! TBRPPickerViewCell
            cell.unit = unit()
        }
    }
    
    func updateFooterTitle() {
        tableView.reloadData()
    }
    
    func footerTitle() -> String? {
        if let unitStr = unitString() {
            return "事件将每" + unitStr + "重复一次"
        }
        return nil
    }
    
    func unit() -> String? {
        if every == 1 {
            return units[(frequency?.rawValue)!]
        } else if every > 1 {
            return pluralUnits[(frequency?.rawValue)!]
        } else {
            return nil
        }
    }
    
    func unitString() -> String? {
        if every == 1 {
            return unit()
        } else if every > 1 {
            return "\(every!) " + unit()!
        } else {
            return nil
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if hasPicker() {
                return 3
            } else {
                return 2
            }
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return footerTitle()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if isPickerCell(indexPath) {
            return TBRPPickerHeight
        }
        
        return 44.0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isPickerCell(indexPath) {
            if indexPath == NSIndexPath(forRow: 1, inSection: 0) {
                let cell = TBRPPickerViewCell(style: .Default, reuseIdentifier: TBRPPickerViewCellID, pickerStyle: .Frequency)
                cell.frequency = frequency
                cell.delegate = self
                cell.selectionStyle = .None
                return cell
            } else {
                let cell = TBRPPickerViewCell(style: .Default, reuseIdentifier: TBRPPickerViewCellID, pickerStyle: .Every)
                cell.unit = unit()
                cell.every = every
                cell.delegate = self
                cell.selectionStyle = .None
                return cell
            }
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier(TBRPCustomRepeatCellID)
            if cell == nil {
                cell = UITableViewCell(style: .Value1, reuseIdentifier: TBRPCustomRepeatCellID)
            }
            
            if indexPath == frequencyTitleIndexpath {
                cell?.textLabel?.text = "频率"
                cell?.detailTextLabel?.text = frequencies[(frequency?.rawValue)!]
            } else if indexPath == everyTitleIndexpath {
                cell?.textLabel?.text = "每"
                cell?.detailTextLabel?.text = unitString()
            }
            
            return cell!;
        }
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath == pickerIndexPath {
            return
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.reuseIdentifier == TBRPCustomRepeatCellID {
            tableView.beginUpdates()
            
            if hasPicker() {
                tableView.deleteRowsAtIndexPaths([pickerIndexPath!], withRowAnimation: .Fade)
                
                if indexPath.row == (pickerIndexPath?.row)! - 1 {
                    pickerIndexPath = nil
                } else {
                    if indexPath == frequencyTitleIndexpath {
                        pickerIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
                    } else {
                        pickerIndexPath = indexPath
                    }
                    
                    tableView.insertRowsAtIndexPaths([pickerIndexPath!], withRowAnimation: .Fade)
                }
            } else if indexPath.section == 0 {
                pickerIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
                tableView.insertRowsAtIndexPaths([pickerIndexPath!], withRowAnimation: .Fade)
            }
            
            tableView.endUpdates()
        }
    }
    
    // MARK: - TBRPPickerCell delegate
    func pickerDidPick(pickerView: UIPickerView, pickStyle: TBRPPickerStyle, didSelectRow row: Int, inComponent component: Int) {
        if pickStyle == .Frequency {
            frequency = TBRPFrequency(rawValue: row)
        } else if pickStyle == .Every {
            every = row + 1
        }
    }
    
}
