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

let TBRPScreenWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
let TBRPScreenHeight: CGFloat = UIScreen.mainScreen().bounds.size.height

private let TBRPCustomRepeatCellID = "TBRPCustomRepeatCell"
private let TBRPPickerViewCellID = "TBRPPickerViewCell"
private let TBRPSwitchCellID = "TBRPSwitchCell"
private let TBRPCollectionViewCellID = "TBRPCollectionViewCell"

class TBRPCustomRepeatController: UITableViewController, TBRPPickerCellDelegate, TBRPSwitchCellDelegate {
    // MARK: - Public properties
    var tintColor: UIColor?
    var locale = NSLocale.currentLocale()
    var frequency: TBRPFrequency? {
        didSet {
            setupData()
            updateFrequencyTitleCell()
            updateEveryTitleCell()
            updateMoreOptions()
            updateFooterTitle()
        }
    }
    var every: Int? {
        didSet {
            updateEveryTitleCell()
            updateFooterTitle()
        }
    }
    var selectedDaysInWeek = [Int]() {
        didSet {
            
        }
    }
    var selectedDaysInMonth = [Int]()
    
    // MARK: - Private properties
    private let frequencyTitleIndexpath = NSIndexPath(forRow: 0, inSection: 0)
    private var everyTitleIndexpath: NSIndexPath? {
        get {
            if hasRepeatPicker() && repeatPickerIndexPath == NSIndexPath(forRow: 1, inSection: 0) {
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
    private var repeatPickerIndexPath: NSIndexPath?
    private var weekPickerIndexPath: NSIndexPath?
    private var showWeekPicker: Bool? {
        didSet {
            if let _ = showWeekPicker {
                updateWeekPickerOptions()
            }
        }
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "自定义";
        
        if let tintColor = tintColor {
            navigationController?.navigationBar.tintColor = tintColor
            tableView.tintColor = tintColor
        }
        
        showWeekPicker = false
    }
    
    // MARK: - Helper
    func weekdays() -> [String] {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = locale
        return dateFormatter.weekdaySymbols
    }
    
    func monthdays() -> [String] {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = locale
        return dateFormatter.monthSymbols
    }
    
    func hasRepeatPicker() -> Bool {
        return repeatPickerIndexPath != nil
    }
    
    func hasWeekPicker() -> Bool {
        return weekPickerIndexPath != nil
    }
    
    func closeRepeatPicker() {
        if !hasRepeatPicker() {
            return;
        }
        
        tableView.deleteRowsAtIndexPaths([repeatPickerIndexPath!], withRowAnimation: .Fade)
    }
    
    func closeWeekPicker() {
        if !hasWeekPicker() {
            return;
        }
        
        tableView.deleteRowsAtIndexPaths([weekPickerIndexPath!], withRowAnimation: .Fade)
    }
    
    func isRepeatPickerCell(indexPath: NSIndexPath) -> Bool {
        return hasRepeatPicker() && repeatPickerIndexPath == indexPath
    }
    
    func isWeekPickerCell(indexPath: NSIndexPath) -> Bool {
        return hasWeekPicker() && weekPickerIndexPath == indexPath
    }
    
    func isMonthsCollectionCell(indexPath: NSIndexPath) -> Bool {
        return indexPath == NSIndexPath(forRow: 0, inSection: 1) && frequency == .Yearly
    }
    
    func isDaysCollectionCell(indexPath: NSIndexPath) -> Bool {
        return indexPath == NSIndexPath(forRow: 2, inSection: 1) && frequency == .Monthly
    }
    
    func setupData() {
        // reset selected days in week
        let todayIndex = NSCalendar.dayIndexInWeek(NSDate(), locale: locale)
        selectedDaysInWeek = [todayIndex]
        
        // refresh weekPickerIndexPath
        if showWeekPicker == true {
            if frequency == .Yearly {
                weekPickerIndexPath = NSIndexPath(forRow: 1, inSection: 2)
            } else if frequency == .Monthly {
                weekPickerIndexPath = NSIndexPath(forRow: 2, inSection: 1)
            }
        }
    }
    
    func updateFrequencyTitleCell() {
        frequencyTitleCell?.detailTextLabel?.text = frequencies[(frequency?.rawValue)!]
    }
    
    func updateEveryTitleCell() {
        everyTitleCell?.detailTextLabel?.text = unitString()
        
        if hasRepeatPicker() && repeatPickerIndexPath == NSIndexPath(forRow: 2, inSection: 0) {
            let cell = tableView.cellForRowAtIndexPath(repeatPickerIndexPath!) as! TBRPPickerViewCell
            cell.unit = unit()
        }
    }
    
    func updateMoreOptions() {
        if frequency == .Daily {
            let deleteRange = NSMakeRange(1, tableView.numberOfSections - 1)
            tableView.deleteSections(NSIndexSet(indexesInRange: deleteRange), withRowAnimation: .Fade)
        } else if frequency == .Weekly || frequency == .Monthly {
            if tableView.numberOfSections == 1 {
                tableView.beginUpdates()
                tableView.insertSections(NSIndexSet(index: 1), withRowAnimation: .Fade)
                tableView.endUpdates()
            } else if tableView.numberOfSections == 2 {
                tableView.beginUpdates()
                tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Fade)
                tableView.endUpdates()
            } else if tableView.numberOfSections == 3 {
                tableView.beginUpdates()
                tableView.deleteSections(NSIndexSet(index: 2), withRowAnimation: .Fade)
                tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Fade)
                tableView.endUpdates()
            }
        } else if frequency == .Yearly {
            if tableView.numberOfSections == 1 {
                let insertYearOptionsRange = NSMakeRange(1, 2)
                tableView.insertSections(NSIndexSet(indexesInRange: insertYearOptionsRange), withRowAnimation: .Fade)
            } else if tableView.numberOfSections == 2 {
                tableView.beginUpdates()
                tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Fade)
                tableView.insertSections(NSIndexSet(index: 2), withRowAnimation: .Fade)
                tableView.endUpdates()
            }
        }
    }
    
    func updateWeekPickerOptions () {
        if frequency == .Monthly {
            tableView.beginUpdates()
            if hasRepeatPicker() {
                closeRepeatPicker()
                repeatPickerIndexPath = nil
            }
            
            
            weekPickerIndexPath = NSIndexPath(forRow: 2, inSection: 1)
            tableView.reloadRowsAtIndexPaths([weekPickerIndexPath!], withRowAnimation: .Fade)
            
            if showWeekPicker == false {
                weekPickerIndexPath = nil
            }
            
            tableView.endUpdates()
        } else if frequency == .Yearly {
            tableView.beginUpdates()
            if hasRepeatPicker() {
                closeRepeatPicker()
                repeatPickerIndexPath = nil
            }
            
            if showWeekPicker == true {
                weekPickerIndexPath = NSIndexPath(forRow: 1, inSection: 2)
                tableView.insertRowsAtIndexPaths([weekPickerIndexPath!], withRowAnimation: .Fade)
            } else if showWeekPicker == false {
                closeWeekPicker()
                weekPickerIndexPath = nil
            }
            
            tableView.endUpdates()
        }
    }
    
    func updateFooterTitle() {
        //tableView.reloadData()
        if let footerTitle = footerTitle() {
            let footerLabel = tableView.footerViewForSection(0)?.textLabel
            footerLabel?.text = footerTitle
        }
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
        if frequency == .Daily {
            return 1
        } else if frequency == .Yearly {
            return 3
        } else {
            return 2
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if hasRepeatPicker() {
                return 3
            } else {
                return 2
            }
        } else if section == 1 {
            if frequency == .Weekly {
                return 7
            } else if frequency == .Monthly {
                return 3
            } else if frequency == .Yearly {
                return 1
            } else {
                return 0
            }
        } else {
            if showWeekPicker == true {
                return 2
            }
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return footerTitle()
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if isRepeatPickerCell(indexPath) || isWeekPickerCell(indexPath) {
            return TBRPPickerHeight
        } else if isMonthsCollectionCell(indexPath) {
            return TBRPMonthsCollectionHeight
        } else if isDaysCollectionCell(indexPath) {
            return TBRPDaysCollectionHeight
        }
        
        return 44.0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if isRepeatPickerCell(indexPath) {
                if indexPath == NSIndexPath(forRow: 1, inSection: 0) {
                    let cell = TBRPPickerViewCell(style: .Default, reuseIdentifier: TBRPPickerViewCellID, pickerStyle: .Frequency)
                    cell.frequency = frequency
                    cell.delegate = self
                    cell.selectionStyle = .None
                    cell.accessoryType = .None
                    return cell
                } else {
                    let cell = TBRPPickerViewCell(style: .Default, reuseIdentifier: TBRPPickerViewCellID, pickerStyle: .Every)
                    cell.unit = unit()
                    cell.every = every
                    cell.delegate = self
                    cell.selectionStyle = .None
                    cell.accessoryType = .None
                    return cell
                }
            } else {
                var cell = tableView.dequeueReusableCellWithIdentifier(TBRPCustomRepeatCellID)
                if cell == nil {
                    cell = UITableViewCell(style: .Value1, reuseIdentifier: TBRPCustomRepeatCellID)
                }
                cell?.selectionStyle = .Default
                cell!.accessoryType = .None
                
                if indexPath == frequencyTitleIndexpath {
                    cell?.textLabel?.text = "频率"
                    cell?.detailTextLabel?.text = frequencies[(frequency?.rawValue)!]
                } else if indexPath == everyTitleIndexpath {
                    cell?.textLabel?.text = "每"
                    cell?.detailTextLabel?.text = unitString()
                }
                
                return cell!
            }
        } else if indexPath.section == 1 {
            if frequency == .Weekly {
                var cell = tableView.dequeueReusableCellWithIdentifier(TBRPCustomRepeatCellID)
                if cell == nil {
                    cell = UITableViewCell(style: .Value1, reuseIdentifier: TBRPCustomRepeatCellID)
                }
                cell?.selectionStyle = .Default
                
                cell?.textLabel?.text = weekdays()[indexPath.row]
                cell?.detailTextLabel?.text = nil
                if selectedDaysInWeek.contains(indexPath.row) == true {
                    cell?.accessoryType = .Checkmark
                } else {
                    cell?.accessoryType = .None
                }
                
                return cell!
            } else if frequency == .Monthly {
                if indexPath.row == 2 {
                    if showWeekPicker == true {
                        let cell = TBRPPickerViewCell(style: .Default, reuseIdentifier: TBRPPickerViewCellID, pickerStyle: .Week)
                        cell.delegate = self
                        cell.selectionStyle = .None
                        cell.accessoryType = .None
                        return cell
                    } else {
                        let cell = TBRPCollectionViewCell(style: .Default, reuseIdentifier: TBRPCollectionViewCellID, mode: .Days)
                        
                        return cell
                    }
                } else {
                    var cell = tableView.dequeueReusableCellWithIdentifier(TBRPCustomRepeatCellID)
                    if cell == nil {
                        cell = UITableViewCell(style: .Value1, reuseIdentifier: TBRPCustomRepeatCellID)
                    }
                    cell?.selectionStyle = .Default
                    
                    switch indexPath.row {
                    case 0:
                        cell?.textLabel?.text = "日期"
                        cell?.selectionStyle = .Default
                        if showWeekPicker == true {
                            cell?.accessoryType = .None
                        } else {
                            cell?.accessoryType = .Checkmark
                        }
                        
                    case 1:
                        cell?.textLabel?.text = "星期"
                        cell?.selectionStyle = .Default
                        if showWeekPicker == true {
                            cell?.accessoryType = .Checkmark
                        } else {
                            cell?.accessoryType = .None
                        }
                        
                    default:
                        cell?.textLabel?.text = nil
                    }
                    cell?.detailTextLabel?.text = nil
                    
                    return cell!
                }
            } else {
                var cell = tableView.dequeueReusableCellWithIdentifier(TBRPCustomRepeatCellID)
                if cell == nil {
                    cell = UITableViewCell(style: .Value1, reuseIdentifier: TBRPCustomRepeatCellID)
                }
                
                cell?.textLabel?.text = nil
                cell?.detailTextLabel?.text = nil
                cell!.selectionStyle = .None
                cell!.accessoryType = .None
                
                return cell!
            }
        } else {
            if indexPath.row == 0 {
                let cell = TBRPSwitchCell(style: .Default, reuseIdentifier: TBRPSwitchCellID)
                
                if let _ = showWeekPicker {
                    cell.weekSwitch?.setOn(showWeekPicker!, animated: true)
                } else {
                    cell.weekSwitch?.setOn(false, animated: false)
                }
                cell.textLabel?.text = "星期"
                cell.selectionStyle = .None
                cell.accessoryType = .None
                cell.delegate = self
                
                return cell
            } else {
                let cell = TBRPPickerViewCell(style: .Default, reuseIdentifier: TBRPPickerViewCellID, pickerStyle: .Week)
                cell.delegate = self
                cell.selectionStyle = .None
                cell.accessoryType = .None
                return cell
            }
        }
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath == repeatPickerIndexPath {
            return
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.reuseIdentifier == TBRPCustomRepeatCellID {
            if indexPath.section == 0 {
                tableView.beginUpdates()
                
                if hasRepeatPicker() {
                    closeRepeatPicker()
                    
                    if indexPath.row == (repeatPickerIndexPath?.row)! - 1 {
                        repeatPickerIndexPath = nil
                    } else {
                        if indexPath == frequencyTitleIndexpath {
                            repeatPickerIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
                        } else {
                            repeatPickerIndexPath = indexPath
                        }
                        
                        tableView.insertRowsAtIndexPaths([repeatPickerIndexPath!], withRowAnimation: .Fade)
                    }
                } else {
                    repeatPickerIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
                    tableView.insertRowsAtIndexPaths([repeatPickerIndexPath!], withRowAnimation: .Fade)
                }
                
                tableView.endUpdates()
            } else if indexPath.section == 1 {
                if frequency == .Weekly {
                    let cell = tableView.cellForRowAtIndexPath(indexPath)
                    
                    if selectedDaysInWeek.contains(indexPath.row) == false {
                        cell?.accessoryType = .Checkmark
                        selectedDaysInWeek.append(indexPath.row)
                    } else if selectedDaysInWeek.count > 1 {
                        cell?.accessoryType = .None
                        selectedDaysInWeek.removeObject(indexPath.row)
                    }
                } else if frequency == .Monthly {
                    let dateCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))
                    let weekCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1))
                    
                    if indexPath.row == 1 && showWeekPicker == false {
                        showWeekPicker = true
                        weekCell?.accessoryType = .Checkmark
                        dateCell?.accessoryType = .None
                    } else if indexPath.row == 0 && showWeekPicker == true {
                        showWeekPicker = false
                        dateCell?.accessoryType = .Checkmark
                        weekCell?.accessoryType = .None
                    }
                }
            }
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
    
    // MARK: - TBRPSwitchCell delegate
    func didSwitch(sender: AnyObject) {
        if let weekSwitch = sender as? UISwitch {
            showWeekPicker = weekSwitch.on
        }
    }
    
}
