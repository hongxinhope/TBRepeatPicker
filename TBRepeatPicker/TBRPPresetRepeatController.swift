//
//  TBRPPresetRepeatController.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/23.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

private let TBRPPresetRepeatCellID = "TBRPPresetRepeatCell"

@objc protocol TBRepeatPickerDelegate {
    func didPickRecurrence(_ recurrence: TBRecurrence?, repeatPicker: TBRepeatPicker)
}

class TBRPPresetRepeatController: UITableViewController, TBRPCustomRepeatControllerDelegate {
    // MARK: - Public properties
    var occurrenceDate = Date()
    var tintColor = UIColor.blue
    var language: TBRPLanguage = .english
    var delegate: TBRepeatPickerDelegate?
    
    var recurrence: TBRecurrence? {
        didSet {
            setupSelectedIndexPath(recurrence)
        }
    }
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    
    // MARK: - Private properties
    fileprivate var recurrenceBackup: TBRecurrence?
    fileprivate var presetRepeats = [String]()
    fileprivate var internationalControl: TBRPInternationalControl?
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()
    }
    
    fileprivate func commonInit() {
        internationalControl = TBRPInternationalControl(language: language)
        navigationItem.title = internationalControl?.localized("TBRPPresetRepeatController.navigation.title", comment: "Repeat")
        
        navigationController?.navigationBar.tintColor = tintColor
        tableView.tintColor = tintColor
        
        presetRepeats = TBRPHelper.presetRepeats(language)
        
        if let _ = recurrence {
            recurrenceBackup = recurrence!.recurrenceCopy()
        }
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            // navigation was popped
            if TBRecurrence.isEqualRecurrence(recurrence, recurrence2: recurrenceBackup) == false {
                if let _ = delegate {
                    delegate?.didPickRecurrence(recurrence, repeatPicker: self as! TBRepeatPicker)
                }
            }
        }
    }
    
    // MARK: - Helper
    fileprivate func setupSelectedIndexPath(_ recurrence: TBRecurrence?) {
        if recurrence == nil {
            selectedIndexPath = IndexPath(row: 0, section: 0)
        } else if recurrence?.isDailyRecurrence() == true {
            selectedIndexPath = IndexPath(row: 1, section: 0)
        } else if recurrence?.isWeeklyRecurrence(occurrenceDate) == true {
            selectedIndexPath = IndexPath(row: 2, section: 0)
        } else if recurrence?.isBiWeeklyRecurrence(occurrenceDate) == true {
            selectedIndexPath = IndexPath(row: 3, section: 0)
        } else if recurrence?.isMonthlyRecurrence(occurrenceDate) == true {
            selectedIndexPath = IndexPath(row: 4, section: 0)
        } else if recurrence?.isYearlyRecurrence(occurrenceDate) == true {
            selectedIndexPath = IndexPath(row: 5, section: 0)
        } else {
            selectedIndexPath = IndexPath(row: 0, section: 1)
        }
    }
    
    fileprivate func updateRecurrence(_ indexPath: IndexPath) {
        if indexPath.section == 1 {
            return
        }
        
        switch indexPath.row {
        case 0:
            recurrence = nil
            
        case 1:
            recurrence = TBRecurrence.dailyRecurrence(occurrenceDate)
        
        case 2:
            recurrence = TBRecurrence.weeklyRecurrence(occurrenceDate)
            
        case 3:
            recurrence = TBRecurrence.biWeeklyRecurrence(occurrenceDate)
            
        case 4:
            recurrence = TBRecurrence.monthlyRecurrence(occurrenceDate)
            
        case 5:
            recurrence = TBRecurrence.yearlyRecurrence(occurrenceDate)
            
        default:
            break
        }
    }
    
    fileprivate func updateFooterTitle() {
        let footerView = tableView.footerView(forSection: 1)
        
        tableView.beginUpdates()
        footerView?.textLabel?.text = footerTitle()
        tableView.endUpdates()
        footerView?.setNeedsLayout()
    }
    
    fileprivate func footerTitle() -> String? {
        if let _ = recurrence {
            if selectedIndexPath.section == 0 {
                return nil
            }
            return TBRPHelper.recurrenceString(recurrence!, occurrenceDate: occurrenceDate, language: language)
        }
        return nil
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return presetRepeats.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 1 && recurrence != nil {
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: TBRPPresetRepeatCellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: TBRPPresetRepeatCellID)
        }
        
        if indexPath.section == 1 {
            cell?.accessoryType = .disclosureIndicator
            cell?.textLabel?.text = internationalControl?.localized("TBRPPresetRepeatController.textLabel.custom", comment: "Custom")
        } else {
            cell?.accessoryType = .none
            cell?.textLabel?.text = presetRepeats[indexPath.row]
        }
        
        cell?.imageView?.image = UIImage(named: "TBRP-Checkmark")?.withRenderingMode(.alwaysTemplate)
        
        if indexPath == selectedIndexPath {
            cell?.imageView?.isHidden = false
        } else {
            cell?.imageView?.isHidden = true
        }
        
        return cell!
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lastSelectedCell = tableView.cellForRow(at: selectedIndexPath)
        let currentSelectedCell = tableView.cellForRow(at: indexPath)
        
        lastSelectedCell?.imageView?.isHidden = true
        currentSelectedCell?.imageView?.isHidden = false
        
        selectedIndexPath = indexPath
        
        if indexPath.section == 1 {
            let customRepeatController = TBRPCustomRepeatController(style: .grouped)
            customRepeatController.occurrenceDate = occurrenceDate
            customRepeatController.tintColor = tintColor
            customRepeatController.language = language
            
            if let _ = recurrence {
                customRepeatController.recurrence = recurrence!
            } else {
                customRepeatController.recurrence = TBRecurrence.dailyRecurrence(occurrenceDate)
            }
            customRepeatController.delegate = self
            
            navigationController?.pushViewController(customRepeatController, animated: true)
        } else {
            updateRecurrence(indexPath)
            updateFooterTitle()
            
            navigationController?.popViewController(animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - TBRPCustomRepeatController delegate
    func didFinishPickingCustomRecurrence(_ recurrence: TBRecurrence) {
        self.recurrence = recurrence
        updateFooterTitle()
        tableView.reloadData()
    }
}
