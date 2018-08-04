//
//  TBRPCustomRepeatController.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/23.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


private let TBRPCustomRepeatCellID = "TBRPCustomRepeatCell"
private let TBRPPickerViewCellID = "TBRPPickerViewCell"
private let TBRPSwitchCellID = "TBRPSwitchCell"
private let TBRPCollectionViewCellID = "TBRPCollectionViewCell"

protocol TBRPCustomRepeatControllerDelegate {
    func didFinishPickingCustomRecurrence(_ recurrence: TBRecurrence)
}

class TBRPCustomRepeatController: UITableViewController, TBRPPickerCellDelegate, TBRPSwitchCellDelegate, TBRPCollectionViewCellDelegate {
    // MARK: - Public properties
    var occurrenceDate = Date()
    var tintColor = UIColor.blue
    var language: TBRPLanguage = .english
    var delegate: TBRPCustomRepeatControllerDelegate?
    
    var recurrence = TBRecurrence() {
        didSet {
            frequency = recurrence.frequency
            interval = recurrence.interval
            selectedWeekdays = recurrence.selectedWeekdays
            byWeekNumber = recurrence.byWeekNumber
            selectedMonthdays = recurrence.selectedMonthdays
            selectedMonths = recurrence.selectedMonths
            pickedWeekNumber = recurrence.pickedWeekNumber
            pickedWeekday = recurrence.pickedWeekday
        }
    }
    var frequency: TBRPFrequency? {
        didSet {
            setupData()
            updateFrequencyTitleCell()
            updateIntervalTitleCell()
            updateMoreOptions()
            
            recurrence.frequency = frequency!
        }
    }
    var interval: Int? {
        didSet {
            updateIntervalTitleCell()
            
            recurrence.interval = interval!
        }
    }
    var selectedWeekdays = [Int]() {
        didSet {
            recurrence.selectedWeekdays = selectedWeekdays
        }
    }
    var selectedMonthdays = [Int]() {
        didSet {
            recurrence.selectedMonthdays = selectedMonthdays
        }
    }
    var selectedMonths = [Int]() {
        didSet {
            recurrence.selectedMonths = selectedMonths
        }
    }
    var pickedWeekNumber: TBRPWeekPickerNumber = .first {
        didSet {
            recurrence.pickedWeekNumber = pickedWeekNumber
        }
    }
    var pickedWeekday: TBRPWeekPickerDay = .sunday {
        didSet {
            recurrence.pickedWeekday = pickedWeekday
        }
    }
    var byWeekNumber: Bool? {
        didSet {
            if let _ = byWeekNumber {
                updateWeekPickerOptions()
                
                recurrence.byWeekNumber = byWeekNumber!
            }
        }
    }
    
    // MARK: - Private properties
    fileprivate var internationalControl: TBRPInternationalControl?
    fileprivate var frequencies = [String]()
    fileprivate var units = [String]()
    fileprivate var pluralUnits = [String]()
    
    fileprivate let frequencyTitleIndexpath = IndexPath(row: 0, section: 0)
    fileprivate var intervalTitleIndexpath: IndexPath? {
        get {
            if hasRepeatPicker() && repeatPickerIndexPath == IndexPath(row: 1, section: 0) {
                return IndexPath(row: 2, section: 0)
            } else {
                return IndexPath(row: 1, section: 0)
            }
        }
    }
    fileprivate var frequencyTitleCell: TBRPCustomRepeatCell? {
        get {
            return tableView.cellForRow(at: frequencyTitleIndexpath) as? TBRPCustomRepeatCell
        }
    }
    fileprivate var intervalTitleCell: TBRPCustomRepeatCell? {
        get {
            return tableView.cellForRow(at: intervalTitleIndexpath!) as? TBRPCustomRepeatCell
        }
    }
    fileprivate var repeatPickerIndexPath: IndexPath?
    fileprivate var weekPickerIndexPath: IndexPath?
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        commonInit()
    }
    
    fileprivate func commonInit() {
        internationalControl = TBRPInternationalControl(language: language)
        navigationItem.title = internationalControl?.localized("TBRPPresetRepeatController.textLabel.custom", comment: "Custom")
        
        navigationController?.navigationBar.tintColor = tintColor
        tableView.tintColor = tintColor
        tableView.separatorStyle = .none
        
        frequencies = TBRPHelper.frequencies(language)
        units = TBRPHelper.units(language)
        pluralUnits = TBRPHelper.pluralUnits(language)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let _ = delegate {
            delegate?.didFinishPickingCustomRecurrence(recurrence)
        }
        
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Helper
    fileprivate func hasRepeatPicker() -> Bool {
        return repeatPickerIndexPath != nil
    }
    
    fileprivate func hasWeekPicker() -> Bool {
        return weekPickerIndexPath != nil
    }
    
    fileprivate func closeRepeatPicker() {
        if !hasRepeatPicker() {
            return;
        }
        
        tableView.deleteRows(at: [repeatPickerIndexPath!], with: .fade)
        repeatPickerIndexPath = nil
        updateDetailTextColor()
    }
    
    fileprivate func closeWeekPicker() {
        if !hasWeekPicker() {
            return;
        }
        
        tableView.deleteRows(at: [weekPickerIndexPath!], with: .fade)
        weekPickerIndexPath = nil
    }
    
    fileprivate func isRepeatPickerCell(_ indexPath: IndexPath) -> Bool {
        return hasRepeatPicker() && repeatPickerIndexPath == indexPath
    }
    
    fileprivate func isWeekPickerCell(_ indexPath: IndexPath) -> Bool {
        return hasWeekPicker() && weekPickerIndexPath == indexPath && (frequency == .monthly || frequency == .yearly)
    }
    
    fileprivate func isMonthsCollectionCell(_ indexPath: IndexPath) -> Bool {
        return indexPath == IndexPath(row: 0, section: 1) && frequency == .yearly
    }
    
    fileprivate func isDaysCollectionCell(_ indexPath: IndexPath) -> Bool {
        return indexPath == IndexPath(row: 2, section: 1) && frequency == .monthly
    }
    
    fileprivate func setupData() {
        // refresh weekPickerIndexPath
        if byWeekNumber == true {
            if frequency == .yearly {
                weekPickerIndexPath = IndexPath(row: 1, section: 2)
            } else if frequency == .monthly {
                weekPickerIndexPath = IndexPath(row: 2, section: 1)
            }
        }
    }
    
    fileprivate func updateFrequencyTitleCell() {
        frequencyTitleCell?.detailTextLabel?.text = frequencies[(frequency?.rawValue)!]
    }
    
    fileprivate func updateIntervalTitleCell() {
        intervalTitleCell?.detailTextLabel?.text = unitString()
        
        if hasRepeatPicker() && repeatPickerIndexPath == IndexPath(row: 2, section: 0) {
            let cell = tableView.cellForRow(at: repeatPickerIndexPath!) as! TBRPPickerViewCell
            cell.unit = unit()
        }
    }
    
    fileprivate func updateDetailTextColor() {
        if repeatPickerIndexPath == IndexPath(row: 1, section: 0) {
            frequencyTitleCell?.detailTextLabel?.textColor = tintColor
        } else if repeatPickerIndexPath == IndexPath(row: 2, section: 0) {
            intervalTitleCell?.detailTextLabel?.textColor = tintColor
        } else {
            let detailTextColor = TBRPHelper.detailTextColor()
            frequencyTitleCell?.detailTextLabel?.textColor = detailTextColor
            intervalTitleCell?.detailTextLabel?.textColor = detailTextColor
        }
    }
    
    fileprivate func updateMoreOptions() {
        if frequency == .daily {
            let deleteRange = NSMakeRange(1, tableView.numberOfSections - 1)
            
            tableView.beginUpdates()
            tableView.deleteSections(IndexSet(integersIn: Range(deleteRange) ?? 0..<0), with: .fade)
            tableView.endUpdates()
        } else if frequency == .weekly || frequency == .monthly {
            if tableView.numberOfSections == 1 {
                tableView.beginUpdates()
                tableView.insertSections(IndexSet(integer: 1), with: .fade)
                tableView.endUpdates()
            } else if tableView.numberOfSections == 2 {
                tableView.beginUpdates()
                tableView.reloadSections(IndexSet(integer: 1), with: .fade)
                tableView.endUpdates()
            } else if tableView.numberOfSections == 3 {
                tableView.beginUpdates()
                tableView.deleteSections(IndexSet(integer: 2), with: .fade)
                tableView.reloadSections(IndexSet(integer: 1), with: .fade)
                tableView.endUpdates()
            }
        } else if frequency == .yearly {
            if tableView.numberOfSections == 1 {
                let insertYearOptionsRange = NSMakeRange(1, 2)
                tableView.insertSections(IndexSet(integersIn: Range(insertYearOptionsRange) ?? 0..<0), with: .fade)
            } else if tableView.numberOfSections == 2 {
                tableView.beginUpdates()
                tableView.reloadSections(IndexSet(integer: 1), with: .fade)
                tableView.insertSections(IndexSet(integer: 2), with: .fade)
                tableView.endUpdates()
            }
        }
    }
    
    fileprivate func updateWeekPickerOptions () {
        if frequency == .monthly {
            tableView.beginUpdates()
            if hasRepeatPicker() {
                closeRepeatPicker()
            }
            
            
            weekPickerIndexPath = IndexPath(row: 2, section: 1)
            tableView.reloadRows(at: [weekPickerIndexPath!], with: .fade)
            
            if byWeekNumber == false {
                weekPickerIndexPath = nil
            }
            
            tableView.endUpdates()
        } else if frequency == .yearly {
            tableView.beginUpdates()
            if hasRepeatPicker() {
                closeRepeatPicker()
            }
            
            if byWeekNumber == true {
                weekPickerIndexPath = IndexPath(row: 1, section: 2)
                tableView.insertRows(at: [weekPickerIndexPath!], with: .fade)
            } else if byWeekNumber == false {
                closeWeekPicker()
            }
            
            tableView.endUpdates()
        }
        
        updateIntervalCellBottomSeparator()
    }
    
    fileprivate func updateFooterTitle() {
        let footerView = tableView.footerView(forSection: 0)
        
        tableView.beginUpdates()
        footerView?.textLabel?.text = footerTitle()
        tableView.endUpdates()
        footerView?.setNeedsLayout()
    }
    
    fileprivate func footerTitle() -> String? {
        return TBRPHelper.recurrenceString(recurrence, occurrenceDate: occurrenceDate, language: language)
    }
    
    fileprivate func unit() -> String? {
        if interval == 1 {
            return units[(frequency?.rawValue)!]
        } else if interval > 1 {
            return pluralUnits[(frequency?.rawValue)!]
        } else {
            return nil
        }
    }
    
    fileprivate func unitString() -> String? {
        if interval == 1 {
            return unit()
        } else if interval > 1 {
            return "\(interval!)" + " " + unit()!
        } else {
            return nil
        }
    }
    
    fileprivate func updateIntervalCellBottomSeparator() {
        if hasRepeatPicker() && intervalTitleIndexpath!.row == 1 {
            intervalTitleCell?.updateBottomSeparatorWithLeftX(TBRPHelper.leadingMargin())
        } else {
            intervalTitleCell?.updateBottomSeparatorWithLeftX(0)
        }
    }
    
    fileprivate func updateYearlyWeekCellBottomSeparator() {
        let yearlyWeekCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! TBRPSwitchCell
        if byWeekNumber == true {
            yearlyWeekCell.updateBottomSeparatorWithLeftX(TBRPHelper.leadingMargin())
        } else {
            yearlyWeekCell.updateBottomSeparatorWithLeftX(0)
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if frequency == .daily {
            return 1
        } else if frequency == .yearly {
            return 3
        } else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if hasRepeatPicker() {
                return 3
            } else {
                return 2
            }
        } else if section == 1 {
            if frequency == .weekly {
                return 7
            } else if frequency == .monthly {
                return 3
            } else if frequency == .yearly {
                return 1
            } else {
                return 0
            }
        } else {
            if byWeekNumber == true {
                return 2
            }
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return footerTitle()
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if view.isKind(of: UITableViewHeaderFooterView.self) {
            let tableViewHeaderFooterView = view as! UITableViewHeaderFooterView
            tableViewHeaderFooterView.textLabel?.font = UIFont.systemFont(ofSize: CGFloat(13.0))
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isRepeatPickerCell(indexPath) || isWeekPickerCell(indexPath) {
           return TBRPPickerHeight
        } else if isMonthsCollectionCell(indexPath) {
            return TBRPMonthsCollectionHeight
        } else if isDaysCollectionCell(indexPath) {
            return TBRPDaysCollectionHeight
        }
        
        return 44.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if isRepeatPickerCell(indexPath) {
                if indexPath == IndexPath(row: 1, section: 0) {
                    let cell = TBRPPickerViewCell(style: .default, reuseIdentifier: TBRPPickerViewCellID, pickerStyle: .frequency, language: language)
                    cell.frequency = frequency
                    cell.delegate = self
                    cell.selectionStyle = .none
                    cell.accessoryType = .none
                    return cell
                } else {
                    let cell = TBRPPickerViewCell(style: .default, reuseIdentifier: TBRPPickerViewCellID, pickerStyle: .interval, language: language)
                    cell.unit = unit()
                    cell.interval = interval
                    cell.delegate = self
                    cell.selectionStyle = .none
                    cell.accessoryType = .none
                    return cell
                }
            } else {
                var cell = tableView.dequeueReusableCell(withIdentifier: TBRPCustomRepeatCellID) as? TBRPCustomRepeatCell
                if cell == nil {
                    cell = TBRPCustomRepeatCell(style: .value1, reuseIdentifier: TBRPCustomRepeatCellID)
                }
                cell?.selectionStyle = .default
                cell!.accessoryType = .none
                
                if indexPath == frequencyTitleIndexpath {
                    cell?.textLabel?.text = internationalControl?.localized("TBRPCustomRepeatController.textLabel.frequency", comment: "Frequency")
                    cell?.detailTextLabel?.text = frequencies[(frequency?.rawValue)!]
                    if hasRepeatPicker() && repeatPickerIndexPath == IndexPath(row: 1, section: 0) {
                        cell?.detailTextLabel?.textColor = tintColor
                    } else {
                        cell?.detailTextLabel?.textColor = TBRPHelper.detailTextColor()
                    }
                    
                    cell?.addSectionTopSeparator()
                } else if indexPath == intervalTitleIndexpath {
                    cell?.textLabel?.text = internationalControl?.localized("TBRPCustomRepeatController.textLabel.interval", comment: "Every")
                    cell?.detailTextLabel?.text = unitString()
                    
                    if hasRepeatPicker() && repeatPickerIndexPath == IndexPath(row: 2, section: 0) {
                        cell?.updateBottomSeparatorWithLeftX(TBRPHelper.leadingMargin())
                        cell?.detailTextLabel?.textColor = tintColor
                    } else {
                        cell?.updateBottomSeparatorWithLeftX(0)
                        cell?.detailTextLabel?.textColor = TBRPHelper.detailTextColor()
                    }
                }
                
                return cell!
            }
        } else if indexPath.section == 1 {
            if frequency == .weekly {
                var cell = tableView.dequeueReusableCell(withIdentifier: TBRPCustomRepeatCellID) as? TBRPCustomRepeatCell
                if cell == nil {
                    cell = TBRPCustomRepeatCell(style: .value1, reuseIdentifier: TBRPCustomRepeatCellID)
                }
                cell?.selectionStyle = .default
                
                cell?.textLabel?.text = TBRPHelper.weekdays(language)[indexPath.row]
                cell?.detailTextLabel?.text = nil
                if selectedWeekdays.contains(indexPath.row) == true {
                    cell?.accessoryType = .checkmark
                } else {
                    cell?.accessoryType = .none
                }
                
                if indexPath.row == 0 {
                    cell?.addSectionTopSeparator()
                } else if indexPath.row == TBRPHelper.weekdays(language).count - 1 {
                    cell?.updateBottomSeparatorWithLeftX(0)
                }
                
                return cell!
            } else if frequency == .monthly {
                if indexPath.row == 2 {
                    if byWeekNumber == true {
                        let cell = TBRPPickerViewCell(style: .default, reuseIdentifier: TBRPPickerViewCellID, pickerStyle: .week, language: language)
                        cell.delegate = self
                        cell.pickedWeekNumber = pickedWeekNumber
                        cell.pickedWeekday = pickedWeekday
                        cell.selectionStyle = .none
                        cell.accessoryType = .none
                        return cell
                    } else {
                        let cell = TBRPCollectionViewCell(style: .default, reuseIdentifier: TBRPCollectionViewCellID, mode: .days, language: language)
                        cell.selectionStyle = .none
                        cell.selectedMonthdays = selectedMonthdays
                        cell.delegate = self
                        
                        return cell
                    }
                } else {
                    var cell = tableView.dequeueReusableCell(withIdentifier: TBRPCustomRepeatCellID) as? TBRPCustomRepeatCell
                    if cell == nil {
                        cell = TBRPCustomRepeatCell(style: .value1, reuseIdentifier: TBRPCustomRepeatCellID)
                    }
                    cell?.selectionStyle = .default
                    
                    switch indexPath.row {
                    case 0:
                        cell?.textLabel?.text = internationalControl?.localized("TBRPCustomRepeatController.textLabel.date", comment: "Each")
                        cell?.selectionStyle = .default
                        if byWeekNumber == true {
                            cell?.accessoryType = .none
                        } else {
                            cell?.accessoryType = .checkmark
                        }
                        cell?.addSectionTopSeparator()
                        
                    case 1:
                        cell?.textLabel?.text = internationalControl?.localized("TBRPCustomRepeatController.weekCell.onThe", comment: "On the...")
                        cell?.selectionStyle = .default
                        if byWeekNumber == true {
                            cell?.accessoryType = .checkmark
                        } else {
                            cell?.accessoryType = .none
                        }
                        
                        cell?.addSectionBottomSeparator()
                        
                    default:
                        cell?.textLabel?.text = nil
                    }
                    cell?.detailTextLabel?.text = nil
                    
                    return cell!
                }
            } else {
                let cell = TBRPCollectionViewCell(style: .default, reuseIdentifier: TBRPCollectionViewCellID, mode: .months, language: language)
                cell.selectionStyle = .none
                cell.selectedMonths = selectedMonths
                cell.delegate = self
                
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell = TBRPSwitchCell(style: .default, reuseIdentifier: TBRPSwitchCellID)
                
                if let _ = byWeekNumber {
                    cell.weekSwitch?.setOn(byWeekNumber!, animated: true)
                } else {
                    cell.weekSwitch?.setOn(false, animated: false)
                }
                cell.textLabel?.text = internationalControl?.localized("TBRPCustomRepeatController.weekCell.daysOfWeek", comment: "Days of Week")
                cell.selectionStyle = .none
                cell.accessoryType = .none
                cell.delegate = self
                
                cell.addSectionTopSeparator()
                if byWeekNumber == true {
                    cell.updateBottomSeparatorWithLeftX(TBRPHelper.leadingMargin())
                } else {
                    cell.updateBottomSeparatorWithLeftX(0)
                }
                return cell
            } else {
                let cell = TBRPPickerViewCell(style: .default, reuseIdentifier: TBRPPickerViewCellID, pickerStyle: .week, language: language)
                cell.delegate = self
                cell.pickedWeekNumber = pickedWeekNumber
                cell.pickedWeekday = pickedWeekday
                cell.selectionStyle = .none
                cell.accessoryType = .none
                return cell
            }
        }
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == repeatPickerIndexPath {
            return
        }
        
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.reuseIdentifier == TBRPCustomRepeatCellID {
            if indexPath.section == 0 {
                tableView.beginUpdates()
                
                if hasRepeatPicker() {
                    let repeatPickerIndexPathTemp = repeatPickerIndexPath
                    closeRepeatPicker()
                    
                    if indexPath.row == (repeatPickerIndexPathTemp!.row) - 1 {
                        
                    } else {
                        if indexPath == frequencyTitleIndexpath {
                            repeatPickerIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                        } else {
                            repeatPickerIndexPath = indexPath
                        }
                        
                        tableView.insertRows(at: [repeatPickerIndexPath!], with: .fade)
                    }
                } else {
                    repeatPickerIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                    tableView.insertRows(at: [repeatPickerIndexPath!], with: .fade)
                }
                
                tableView.endUpdates()
                
                updateIntervalCellBottomSeparator()
                updateDetailTextColor()
            } else if indexPath.section == 1 {
                if frequency == .weekly {
                    if hasRepeatPicker() {
                        tableView.beginUpdates()
                        closeRepeatPicker()
                        tableView.endUpdates()
                        
                        updateIntervalCellBottomSeparator()
                    }
                    
                    let cell = tableView.cellForRow(at: indexPath)
                    let day = indexPath.row
                    
                    if selectedWeekdays.count == 1 && selectedWeekdays.contains(day) == true {
                        return
                    }
                    
                    if selectedWeekdays.contains(day) == true {
                        cell?.accessoryType = .none
                        selectedWeekdays.removeObject(day)
                    } else {
                        cell?.accessoryType = .checkmark
                        selectedWeekdays.append(day)
                    }
                    
                    updateFooterTitle()
                } else if frequency == .monthly {
                    let dateCellIndexPath = IndexPath(row: 0, section: 1)
                    let weekCellIndexPath = IndexPath(row: 1, section: 1)
                    let dateCell = tableView.cellForRow(at: dateCellIndexPath)
                    let weekCell = tableView.cellForRow(at: weekCellIndexPath)
                    
                    if indexPath == weekCellIndexPath && byWeekNumber == false {
                        byWeekNumber = true
                        weekCell?.accessoryType = .checkmark
                        dateCell?.accessoryType = .none
                    } else if indexPath == dateCellIndexPath && byWeekNumber == true {
                        byWeekNumber = false
                        dateCell?.accessoryType = .checkmark
                        weekCell?.accessoryType = .none
                    }
                    
                    updateFooterTitle()
                }
            }
        }
    }
    
    // MARK: - TBRPPickerCell delegate
    func pickerDidPick(_ pickerView: UIPickerView, pickStyle: TBRPPickerStyle, didSelectRow row: Int, inComponent component: Int) {
        if pickStyle == .frequency {
            frequency = TBRPFrequency(rawValue: row)
        } else if pickStyle == .interval {
            if component == 0 {
                interval = row + 1
            }
        } else if pickStyle == .week {
            if hasRepeatPicker() {
                tableView.beginUpdates()
                closeRepeatPicker()
                tableView.endUpdates()
                
                updateIntervalCellBottomSeparator()
            }
            
            if component == 0 {
                pickedWeekNumber = TBRPWeekPickerNumber(rawValue: row)!
            } else if component == 1 {
                pickedWeekday = TBRPWeekPickerDay(rawValue: row)!
            }
        }
        
        updateFooterTitle()
    }
    
    // MARK: - TBRPSwitchCell delegate
    func didSwitch(_ sender: AnyObject) {
        if let weekSwitch = sender as? UISwitch {
            byWeekNumber = weekSwitch.isOn
            
            updateYearlyWeekCellBottomSeparator()
            updateFooterTitle()
        }
    }
    
    
    // MARK: - TBRPCollectionViewCell delegate
    func selectedMonthdaysDidChanged(_ days: [Int]) {
        if hasRepeatPicker() {
            tableView.beginUpdates()
            closeRepeatPicker()
            tableView.endUpdates()
            
            updateIntervalCellBottomSeparator()
        }
        
        selectedMonthdays = days
        
        updateFooterTitle()
    }
    
    func selectedMonthsDidChanged(_ months: [Int]) {
        if hasRepeatPicker() {
            tableView.beginUpdates()
            closeRepeatPicker()
            tableView.endUpdates()
            
            updateIntervalCellBottomSeparator()
        }
        
        selectedMonths = months
        
        updateFooterTitle()
    }
}
