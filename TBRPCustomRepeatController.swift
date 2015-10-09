//
//  TBRPCustomRepeatController.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/23.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

private let TBRPCustomRepeatCellID = "TBRPCustomRepeatCell"
private let TBRPPickerViewCellID = "TBRPPickerViewCell"
private let TBRPSwitchCellID = "TBRPSwitchCell"
private let TBRPCollectionViewCellID = "TBRPCollectionViewCell"

protocol TBRPCustomRepeatControllerDelegate {
    func didFinishPickingCustomRecurrence(recurrence: TBRecurrence)
}

class TBRPCustomRepeatController: UITableViewController, TBRPPickerCellDelegate, TBRPSwitchCellDelegate, TBRPCollectionViewCellDelegate {
    // MARK: - Public properties
    var tintColor = UIColor.blueColor()
    var locale = NSLocale.currentLocale()
    var language: TBRPLanguage = .English
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
    var pickedWeekNumber: TBRPWeekPickerNumber = .First {
        didSet {
            recurrence.pickedWeekNumber = pickedWeekNumber
        }
    }
    var pickedWeekday: TBRPWeekPickerDay = .Sunday {
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
    private var internationalControl: TBRPInternationalControl?
    private var frequencies = [String]()
    private var units = [String]()
    private var pluralUnits = [String]()
    
    private let frequencyTitleIndexpath = NSIndexPath(forRow: 0, inSection: 0)
    private var intervalTitleIndexpath: NSIndexPath? {
        get {
            if hasRepeatPicker() && repeatPickerIndexPath == NSIndexPath(forRow: 1, inSection: 0) {
                return NSIndexPath(forRow: 2, inSection: 0)
            } else {
                return NSIndexPath(forRow: 1, inSection: 0)
            }
        }
    }
    private var frequencyTitleCell: TBRPCustomRepeatCell? {
        get {
            return tableView.cellForRowAtIndexPath(frequencyTitleIndexpath) as? TBRPCustomRepeatCell
        }
    }
    private var intervalTitleCell: TBRPCustomRepeatCell? {
        get {
            return tableView.cellForRowAtIndexPath(intervalTitleIndexpath!) as? TBRPCustomRepeatCell
        }
    }
    private var repeatPickerIndexPath: NSIndexPath?
    private var weekPickerIndexPath: NSIndexPath?
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        commonInit()
    }
    
    private func commonInit() {
        internationalControl = TBRPInternationalControl(language: language)
        navigationItem.title = internationalControl?.localized("TBRPPresetRepeatController.textLabel.custom", comment: "Custom")
        
        navigationController?.navigationBar.tintColor = tintColor
        tableView.tintColor = tintColor
        tableView.separatorStyle = .None
        
        frequencies = TBRPHelper.frequencies(language)
        units = TBRPHelper.units(language)
        pluralUnits = TBRPHelper.pluralUnits(language)
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let _ = delegate {
            delegate?.didFinishPickingCustomRecurrence(recurrence)
        }
        
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Helper
    private func hasRepeatPicker() -> Bool {
        return repeatPickerIndexPath != nil
    }
    
    private func hasWeekPicker() -> Bool {
        return weekPickerIndexPath != nil
    }
    
    private func closeRepeatPicker() {
        if !hasRepeatPicker() {
            return;
        }
        
        tableView.deleteRowsAtIndexPaths([repeatPickerIndexPath!], withRowAnimation: .Fade)
        repeatPickerIndexPath = nil
        updateDetailTextColor()
    }
    
    private func closeWeekPicker() {
        if !hasWeekPicker() {
            return;
        }
        
        tableView.deleteRowsAtIndexPaths([weekPickerIndexPath!], withRowAnimation: .Fade)
        weekPickerIndexPath = nil
    }
    
    private func isRepeatPickerCell(indexPath: NSIndexPath) -> Bool {
        return hasRepeatPicker() && repeatPickerIndexPath == indexPath
    }
    
    private func isWeekPickerCell(indexPath: NSIndexPath) -> Bool {
        return hasWeekPicker() && weekPickerIndexPath == indexPath && (frequency == .Monthly || frequency == .Yearly)
    }
    
    private func isMonthsCollectionCell(indexPath: NSIndexPath) -> Bool {
        return indexPath == NSIndexPath(forRow: 0, inSection: 1) && frequency == .Yearly
    }
    
    private func isDaysCollectionCell(indexPath: NSIndexPath) -> Bool {
        return indexPath == NSIndexPath(forRow: 2, inSection: 1) && frequency == .Monthly
    }
    
    private func setupData() {
        // refresh weekPickerIndexPath
        if byWeekNumber == true {
            if frequency == .Yearly {
                weekPickerIndexPath = NSIndexPath(forRow: 1, inSection: 2)
            } else if frequency == .Monthly {
                weekPickerIndexPath = NSIndexPath(forRow: 2, inSection: 1)
            }
        }
    }
    
    private func updateFrequencyTitleCell() {
        frequencyTitleCell?.detailTextLabel?.text = frequencies[(frequency?.rawValue)!]
    }
    
    private func updateIntervalTitleCell() {
        intervalTitleCell?.detailTextLabel?.text = unitString()
        
        if hasRepeatPicker() && repeatPickerIndexPath == NSIndexPath(forRow: 2, inSection: 0) {
            let cell = tableView.cellForRowAtIndexPath(repeatPickerIndexPath!) as! TBRPPickerViewCell
            cell.unit = unit()
        }
    }
    
    private func updateDetailTextColor() {
        if repeatPickerIndexPath == NSIndexPath(forRow: 1, inSection: 0) {
            frequencyTitleCell?.detailTextLabel?.textColor = tintColor
        } else if repeatPickerIndexPath == NSIndexPath(forRow: 2, inSection: 0) {
            intervalTitleCell?.detailTextLabel?.textColor = tintColor
        } else {
            let detailTextColor = TBRPHelper.detailTextColor()
            frequencyTitleCell?.detailTextLabel?.textColor = detailTextColor
            intervalTitleCell?.detailTextLabel?.textColor = detailTextColor
        }
    }
    
    private func updateMoreOptions() {
        if frequency == .Daily {
            let deleteRange = NSMakeRange(1, tableView.numberOfSections - 1)
            
            tableView.beginUpdates()
            tableView.deleteSections(NSIndexSet(indexesInRange: deleteRange), withRowAnimation: .Fade)
            tableView.endUpdates()
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
    
    private func updateWeekPickerOptions () {
        if frequency == .Monthly {
            tableView.beginUpdates()
            if hasRepeatPicker() {
                closeRepeatPicker()
            }
            
            
            weekPickerIndexPath = NSIndexPath(forRow: 2, inSection: 1)
            tableView.reloadRowsAtIndexPaths([weekPickerIndexPath!], withRowAnimation: .Fade)
            
            if byWeekNumber == false {
                weekPickerIndexPath = nil
            }
            
            tableView.endUpdates()
        } else if frequency == .Yearly {
            tableView.beginUpdates()
            if hasRepeatPicker() {
                closeRepeatPicker()
            }
            
            if byWeekNumber == true {
                weekPickerIndexPath = NSIndexPath(forRow: 1, inSection: 2)
                tableView.insertRowsAtIndexPaths([weekPickerIndexPath!], withRowAnimation: .Fade)
            } else if byWeekNumber == false {
                closeWeekPicker()
            }
            
            tableView.endUpdates()
        }
        
        updateIntervalCellBottomSeparator()
    }
    
    private func updateFooterTitle() {
        let footerView = tableView.footerViewForSection(0)
        
        tableView.beginUpdates()
        footerView?.textLabel?.text = footerTitle()
        tableView.endUpdates()
        footerView?.setNeedsLayout()
    }
    
    private func footerTitle() -> String? {
        return TBRPHelper.recurrenceString(recurrence, language: language, locale: locale)
    }
    
    private func unit() -> String? {
        if interval == 1 {
            return units[(frequency?.rawValue)!]
        } else if interval > 1 {
            return pluralUnits[(frequency?.rawValue)!]
        } else {
            return nil
        }
    }
    
    private func unitString() -> String? {
        if interval == 1 {
            return unit()
        } else if interval > 1 {
            return "\(interval!)" + " " + unit()!
        } else {
            return nil
        }
    }
    
    private func updateIntervalCellBottomSeparator() {
        if hasRepeatPicker() && intervalTitleIndexpath!.row == 1 {
            intervalTitleCell?.updateBottomSeparatorWithLeftX(TBRPHelper.leadingMargin())
        } else {
            intervalTitleCell?.updateBottomSeparatorWithLeftX(0)
        }
    }
    
    private func updateYearlyWeekCellBottomSeparator() {
        let yearlyWeekCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2)) as! TBRPSwitchCell
        if byWeekNumber == true {
            yearlyWeekCell.updateBottomSeparatorWithLeftX(TBRPHelper.leadingMargin())
        } else {
            yearlyWeekCell.updateBottomSeparatorWithLeftX(0)
        }
    }
    
    private func sortSelectedWeekdays() {
        if selectedWeekdays.count < 2 {
            return
        }
        selectedWeekdays = selectedWeekdays.sort { $0 < $1 }
    }
    
    private func sortSelectedMonthdays() {
        if selectedMonthdays.count < 2 {
            return
        }
        selectedMonthdays = selectedMonthdays.sort { $0 < $1 }
    }
    
    private func sortSelectedMonths() {
        if selectedMonths.count < 2 {
            return
        }
        selectedMonths = selectedMonths.sort { $0 < $1 }
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
            if byWeekNumber == true {
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
                    let cell = TBRPPickerViewCell(style: .Default, reuseIdentifier: TBRPPickerViewCellID, pickerStyle: .Frequency, language: language)
                    cell.frequency = frequency
                    cell.delegate = self
                    cell.selectionStyle = .None
                    cell.accessoryType = .None
                    return cell
                } else {
                    let cell = TBRPPickerViewCell(style: .Default, reuseIdentifier: TBRPPickerViewCellID, pickerStyle: .Interval, language: language)
                    cell.unit = unit()
                    cell.interval = interval
                    cell.delegate = self
                    cell.selectionStyle = .None
                    cell.accessoryType = .None
                    return cell
                }
            } else {
                var cell = tableView.dequeueReusableCellWithIdentifier(TBRPCustomRepeatCellID) as? TBRPCustomRepeatCell
                if cell == nil {
                    cell = TBRPCustomRepeatCell(style: .Value1, reuseIdentifier: TBRPCustomRepeatCellID)
                }
                cell?.selectionStyle = .Default
                cell!.accessoryType = .None
                
                if indexPath == frequencyTitleIndexpath {
                    cell?.textLabel?.text = internationalControl?.localized("TBRPCustomRepeatController.textLabel.frequency", comment: "Frequency")
                    cell?.detailTextLabel?.text = frequencies[(frequency?.rawValue)!]
                    if hasRepeatPicker() && repeatPickerIndexPath == NSIndexPath(forRow: 1, inSection: 0) {
                        cell?.detailTextLabel?.textColor = tintColor
                    } else {
                        cell?.detailTextLabel?.textColor = TBRPHelper.detailTextColor()
                    }
                    
                    cell?.addSectionTopSeparator()
                } else if indexPath == intervalTitleIndexpath {
                    cell?.textLabel?.text = internationalControl?.localized("TBRPCustomRepeatController.textLabel.interval", comment: "Every")
                    cell?.detailTextLabel?.text = unitString()
                    
                    if hasRepeatPicker() && repeatPickerIndexPath == NSIndexPath(forRow: 2, inSection: 0) {
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
            if frequency == .Weekly {
                var cell = tableView.dequeueReusableCellWithIdentifier(TBRPCustomRepeatCellID) as? TBRPCustomRepeatCell
                if cell == nil {
                    cell = TBRPCustomRepeatCell(style: .Value1, reuseIdentifier: TBRPCustomRepeatCellID)
                }
                cell?.selectionStyle = .Default
                
                cell?.textLabel?.text = TBRPHelper.weekdays(language)[indexPath.row]
                cell?.detailTextLabel?.text = nil
                if selectedWeekdays.contains(indexPath.row) == true {
                    cell?.accessoryType = .Checkmark
                } else {
                    cell?.accessoryType = .None
                }
                
                if indexPath.row == 0 {
                    cell?.addSectionTopSeparator()
                } else if indexPath.row == TBRPHelper.weekdays(language).count - 1 {
                    cell?.updateBottomSeparatorWithLeftX(0)
                }
                
                return cell!
            } else if frequency == .Monthly {
                if indexPath.row == 2 {
                    if byWeekNumber == true {
                        let cell = TBRPPickerViewCell(style: .Default, reuseIdentifier: TBRPPickerViewCellID, pickerStyle: .Week, language: language)
                        cell.delegate = self
                        cell.pickedWeekNumber = pickedWeekNumber
                        cell.pickedWeekday = pickedWeekday
                        cell.selectionStyle = .None
                        cell.accessoryType = .None
                        return cell
                    } else {
                        let cell = TBRPCollectionViewCell(style: .Default, reuseIdentifier: TBRPCollectionViewCellID, mode: .Days, language: language)
                        cell.selectionStyle = .None
                        cell.selectedMonthdays = selectedMonthdays
                        cell.delegate = self
                        
                        return cell
                    }
                } else {
                    var cell = tableView.dequeueReusableCellWithIdentifier(TBRPCustomRepeatCellID) as? TBRPCustomRepeatCell
                    if cell == nil {
                        cell = TBRPCustomRepeatCell(style: .Value1, reuseIdentifier: TBRPCustomRepeatCellID)
                    }
                    cell?.selectionStyle = .Default
                    
                    switch indexPath.row {
                    case 0:
                        cell?.textLabel?.text = internationalControl?.localized("TBRPCustomRepeatController.textLabel.date", comment: "Each")
                        cell?.selectionStyle = .Default
                        if byWeekNumber == true {
                            cell?.accessoryType = .None
                        } else {
                            cell?.accessoryType = .Checkmark
                        }
                        cell?.addSectionTopSeparator()
                        
                    case 1:
                        cell?.textLabel?.text = internationalControl?.localized("TBRPCustomRepeatController.weekCell.onThe", comment: "On the...")
                        cell?.selectionStyle = .Default
                        if byWeekNumber == true {
                            cell?.accessoryType = .Checkmark
                        } else {
                            cell?.accessoryType = .None
                        }
                        
                        cell?.addSectionBottomSeparator()
                        
                    default:
                        cell?.textLabel?.text = nil
                    }
                    cell?.detailTextLabel?.text = nil
                    
                    return cell!
                }
            } else {
                let cell = TBRPCollectionViewCell(style: .Default, reuseIdentifier: TBRPCollectionViewCellID, mode: .Months, language: language)
                cell.selectionStyle = .None
                cell.selectedMonths = selectedMonths
                cell.delegate = self
                
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell = TBRPSwitchCell(style: .Default, reuseIdentifier: TBRPSwitchCellID)
                
                if let _ = byWeekNumber {
                    cell.weekSwitch?.setOn(byWeekNumber!, animated: true)
                } else {
                    cell.weekSwitch?.setOn(false, animated: false)
                }
                cell.textLabel?.text = internationalControl?.localized("TBRPCustomRepeatController.weekCell.daysOfWeek", comment: "Days of Week")
                cell.selectionStyle = .None
                cell.accessoryType = .None
                cell.delegate = self
                
                cell.addSectionTopSeparator()
                if byWeekNumber == true {
                    cell.updateBottomSeparatorWithLeftX(TBRPHelper.leadingMargin())
                } else {
                    cell.updateBottomSeparatorWithLeftX(0)
                }
                return cell
            } else {
                let cell = TBRPPickerViewCell(style: .Default, reuseIdentifier: TBRPPickerViewCellID, pickerStyle: .Week, language: language)
                cell.delegate = self
                cell.pickedWeekNumber = pickedWeekNumber
                cell.pickedWeekday = pickedWeekday
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
                    let repeatPickerIndexPathTemp = repeatPickerIndexPath
                    closeRepeatPicker()
                    
                    if indexPath.row == (repeatPickerIndexPathTemp!.row) - 1 {
                        
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
                
                updateIntervalCellBottomSeparator()
                updateDetailTextColor()
            } else if indexPath.section == 1 {
                if frequency == .Weekly {
                    if hasRepeatPicker() {
                        tableView.beginUpdates()
                        closeRepeatPicker()
                        tableView.endUpdates()
                        
                        updateIntervalCellBottomSeparator()
                    }
                    
                    let cell = tableView.cellForRowAtIndexPath(indexPath)
                    let day = indexPath.row
                    
                    if selectedWeekdays.count == 1 && selectedWeekdays.contains(day) == true {
                        return
                    }
                    
                    if selectedWeekdays.contains(day) == true {
                        cell?.accessoryType = .None
                        selectedWeekdays.removeObject(day)
                    } else {
                        cell?.accessoryType = .Checkmark
                        selectedWeekdays.append(day)
                    }
                    
                    sortSelectedWeekdays()
                    updateFooterTitle()
                } else if frequency == .Monthly {
                    let dateCellIndexPath = NSIndexPath(forRow: 0, inSection: 1)
                    let weekCellIndexPath = NSIndexPath(forRow: 1, inSection: 1)
                    let dateCell = tableView.cellForRowAtIndexPath(dateCellIndexPath)
                    let weekCell = tableView.cellForRowAtIndexPath(weekCellIndexPath)
                    
                    if indexPath == weekCellIndexPath && byWeekNumber == false {
                        byWeekNumber = true
                        weekCell?.accessoryType = .Checkmark
                        dateCell?.accessoryType = .None
                    } else if indexPath == dateCellIndexPath && byWeekNumber == true {
                        byWeekNumber = false
                        dateCell?.accessoryType = .Checkmark
                        weekCell?.accessoryType = .None
                    }
                    
                    updateFooterTitle()
                }
            }
        }
    }
    
    // MARK: - TBRPPickerCell delegate
    func pickerDidPick(pickerView: UIPickerView, pickStyle: TBRPPickerStyle, didSelectRow row: Int, inComponent component: Int) {
        if pickStyle == .Frequency {
            frequency = TBRPFrequency(rawValue: row)
        } else if pickStyle == .Interval {
            if component == 0 {
                interval = row + 1
            }
        } else if pickStyle == .Week {
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
    func didSwitch(sender: AnyObject) {
        if let weekSwitch = sender as? UISwitch {
            byWeekNumber = weekSwitch.on
            
            updateYearlyWeekCellBottomSeparator()
            updateFooterTitle()
        }
    }
    
    
    // MARK: - TBRPCollectionViewCell delegate
    func selectedMonthdaysDidChanged(days: [Int]) {
        if hasRepeatPicker() {
            tableView.beginUpdates()
            closeRepeatPicker()
            tableView.endUpdates()
            
            updateIntervalCellBottomSeparator()
        }
        
        selectedMonthdays = days
        
        sortSelectedMonthdays()
        updateFooterTitle()
    }
    
    func selectedMonthsDidChanged(months: [Int]) {
        if hasRepeatPicker() {
            tableView.beginUpdates()
            closeRepeatPicker()
            tableView.endUpdates()
            
            updateIntervalCellBottomSeparator()
        }
        
        selectedMonths = months
        
        sortSelectedMonths()
        updateFooterTitle()
    }
}
