//
//  TBRPPresetRepeatController.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/23.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

private let TBRPPresetRepeatCellID = "TBRPPresetRepeatCell"

protocol TBRepeatPickerDelegate {
    func didPickRecurrence(recurrence: TBRecurrence?)
}

class TBRPPresetRepeatController: UITableViewController, TBRPCustomRepeatControllerDelegate {
    // MARK: - Public properties
    var tintColor = UIColor.blueColor()
    var locale = NSLocale.currentLocale()
    var language: TBRPLanguage = .English
    var delegate: TBRepeatPickerDelegate?
    
    var recurrence: TBRecurrence? {
        didSet {
            setupSelectedIndexPath(recurrence)
        }
    }
    var selectedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    // MARK: - Private properties
    private var presetRepeat = [String]()
    private var internationalControl: TBRPInternationalControl?
    private let customRecurrenceIndexPath = NSIndexPath(forRow: 0, inSection: 1)
    
    // MARK: - View life cycle
    class func initWith(locale: NSLocale, language: TBRPLanguage, tintColor: UIColor) -> TBRPPresetRepeatController {
        let presetRepeatController = TBRPPresetRepeatController.init(style: .Grouped)
        
        presetRepeatController.locale = locale
        presetRepeatController.language = language
        presetRepeatController.tintColor = tintColor
        
        return presetRepeatController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()
    }
    
    private func commonInit() {
        internationalControl = TBRPInternationalControl(language: language)
        navigationItem.title = internationalControl?.localized("TBRPPresetRepeatController.navigation.title", comment: "Repeat")
        
        navigationController?.navigationBar.tintColor = tintColor
        tableView.tintColor = tintColor
        
        presetRepeat = TBRPHelper.presetRepeat(language)
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let _ = delegate {
            delegate?.didPickRecurrence(recurrence)
        }
        
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Helper
    private func setupSelectedIndexPath(recurrence: TBRecurrence?) {
        let todayIndexInWeek = NSCalendar.dayIndexInWeek(NSDate(), locale: locale)
        let todayIndexInMonth = NSCalendar.dayIndexInMonth(NSDate(), locale: locale)
        let todayMonthIndex = NSCalendar.monthIndexInYear(NSDate(), locale: locale)
        
        if recurrence == nil {
            selectedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        } else if recurrence!.frequency == .Daily && recurrence!.interval == 1 {
            selectedIndexPath = NSIndexPath(forRow: 1, inSection: 0)
        } else if recurrence!.frequency == .Weekly && recurrence!.selectedWeekdays == [todayIndexInWeek - 1] {
            if recurrence!.interval == 1 {
                selectedIndexPath = NSIndexPath(forRow: 2, inSection: 0)
            } else if recurrence!.interval == 2 {
                selectedIndexPath = NSIndexPath(forRow: 3, inSection: 0)
            } else {
                selectedIndexPath = customRecurrenceIndexPath
            }
        } else if recurrence!.frequency == .Monthly && recurrence!.interval == 1 && recurrence!.byWeekNumber == false && recurrence!.selectedMonthdays == [todayIndexInMonth] {
            selectedIndexPath = NSIndexPath(forRow: 4, inSection: 0)
        } else if recurrence!.frequency == .Yearly && recurrence!.interval == 1 && recurrence!.byWeekNumber == false && recurrence!.selectedMonths == [todayMonthIndex] {
            selectedIndexPath = NSIndexPath(forRow: 5, inSection: 0)
        } else {
            selectedIndexPath = customRecurrenceIndexPath
        }
    }
    
    private func updateRecurrence(indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            return
        }
        
        switch indexPath.row {
        case 0:
            recurrence = nil
            
        case 1:
            recurrence = TBRecurrence.initDaily(1, locale: locale)
        
        case 2:
            recurrence = TBRecurrence.initWeekly(1, selectedWeekdays: [], locale: locale)
            
        case 3:
            recurrence = TBRecurrence.initWeekly(2, selectedWeekdays: [], locale: locale)
            
        case 4:
            recurrence = TBRecurrence.initMonthly(1, selectedMonthdays: [], locale: locale)
            
        case 5:
            recurrence = TBRecurrence.initYearly(1, selectedMonths: [], locale: locale)
            
        default:
            break
        }
    }
    
    private func updateFooterTitle() {
        let footerView = tableView.footerViewForSection(1)
        
        tableView.beginUpdates()
        footerView?.textLabel?.text = footerTitle()
        tableView.endUpdates()
        footerView?.setNeedsLayout()
    }
    
    private func footerTitle() -> String? {
        if let _ = recurrence {
            if selectedIndexPath.section == 0 {
                return nil
            }
            return TBRPHelper.recurrenceString(recurrence!, language: language, locale: locale)
        }
        return nil
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 6
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 1 && recurrence != nil {
            return footerTitle()
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(TBRPPresetRepeatCellID)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: TBRPPresetRepeatCellID)
        }
        
        if indexPath.section == 1 {
            cell?.accessoryType = .DisclosureIndicator
            cell?.textLabel?.text = internationalControl?.localized("TBRPPresetRepeatController.textLabel.custom", comment: "Custom")
        } else {
            cell?.accessoryType = .None
            cell?.textLabel?.text = presetRepeat[indexPath.row]
        }
        
        cell?.imageView?.image = UIImage(named: "TBRP-Checkmark")?.imageWithRenderingMode(.AlwaysTemplate)
        
        if indexPath == selectedIndexPath {
            cell?.imageView?.hidden = false
        } else {
            cell?.imageView?.hidden = true
        }
        
        return cell!
    }

    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let lastSelectedCell = tableView.cellForRowAtIndexPath(selectedIndexPath)
        let currentSelectedCell = tableView.cellForRowAtIndexPath(indexPath)
        
        lastSelectedCell?.imageView?.hidden = true
        currentSelectedCell?.imageView?.hidden = false
        
        selectedIndexPath = indexPath
        
        if indexPath.section == 1 {
            let customRepeatController = TBRPCustomRepeatController(style: .Grouped)
            customRepeatController.tintColor = tintColor
            customRepeatController.locale = locale
            customRepeatController.language = language
            
            if let _ = recurrence {
                customRepeatController.recurrence = recurrence!
            } else {
                customRepeatController.recurrence = TBRecurrence.initDaily(1, locale: locale)
            }
            customRepeatController.delegate = self
            
            navigationController?.pushViewController(customRepeatController, animated: true)
        } else {
            updateRecurrence(indexPath)
            updateFooterTitle()
            
            navigationController?.popViewControllerAnimated(true)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - TBRPCustomRepeatController delegate
    func didFinishPickingCustomRecurrence(recurrence: TBRecurrence) {
        self.recurrence = recurrence
        updateFooterTitle()
        tableView.reloadData()
    }
}
