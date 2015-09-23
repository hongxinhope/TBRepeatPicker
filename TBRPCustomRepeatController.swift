//
//  TBRPCustomRepeatController.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/23.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

enum TBRPFrequency {
    case Daily
    case Weekly
    case Monthly
    case Yearly
}

private let TBRPCustomRepeatCellID = "TBRPCustomRepeatCell"
private let TBRPPickerHeight: CGFloat = 215.0

class TBRPCustomRepeatController: UITableViewController {
    // MARK: - Public properties
    var tintColor: UIColor?
    var locale = NSLocale.currentLocale()
    var frequency = TBRPFrequency.Daily
    var every = 1
    
    // MARK: - Private properties
    private var isPickingFrequency = false
    private var isPickingEvery = false
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "自定义";
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Frequency cell
        if indexPath.section == 0 && indexPath.row == 1 {
            if isPickingFrequency == true {
                return TBRPPickerHeight
            } else {
                return 0
            }
        }
        // Every cell
        if indexPath.section == 0 && indexPath.row == 3 {
            if isPickingEvery == true {
                return TBRPPickerHeight
            } else {
                return 0
            }
        }
        
        return 44.0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(TBRPCustomRepeatCellID)
        if (cell == nil) {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: TBRPCustomRepeatCellID)
        }
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell?.textLabel?.text = "频率"
                switch frequency {
                case .Daily:
                    cell?.detailTextLabel?.text = "每天"
                case .Weekly:
                    cell?.detailTextLabel?.text = "每周"
                case .Monthly:
                    cell?.detailTextLabel?.text = "每月"
                case .Yearly:
                    cell?.detailTextLabel?.text = "每年"
                }
                
            case 1:
                cell?.selectionStyle = .None
                
            case 2:
                cell?.textLabel?.text = "每"
                switch frequency {
                case .Daily:
                    cell?.detailTextLabel?.text = "天"
                case .Weekly:
                    cell?.detailTextLabel?.text = "周"
                case .Monthly:
                    cell?.detailTextLabel?.text = "月"
                case .Yearly:
                    cell?.detailTextLabel?.text = "年"
                }
                
            case 3:
                cell?.selectionStyle = .None
                
            default: break
            }
        } else {
            
        }

        return cell!
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isPickingFrequency == true {
            isPickingFrequency = false
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Automatic)
        } else if indexPath.section == 0 && indexPath.row == 0 {
            isPickingFrequency = true
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Automatic)
        }
        
        if isPickingEvery == true {
            isPickingEvery = false
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 3, inSection: 0)], withRowAnimation: .Automatic)
        } else if indexPath.section == 0 && indexPath.row == 2 {
            isPickingEvery = true
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 3, inSection: 0)], withRowAnimation: .Automatic)
        }
        
        
        
//        if indexPath.section == 0 {
//            switch indexPath.row {
//            case 0:
//                isPickingFrequency = !isPickingFrequency
//                tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Fade)
//                if isPickingEvery == true {
//                    isPickingEvery = false
//                    tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 3, inSection: 0)], withRowAnimation: .Fade)
//                }
//                
//            case 1: break
//                
//                
//            case 2:
//                isPickingEvery = !isPickingEvery
//                tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 3, inSection: 0)], withRowAnimation: .Fade)
//                if isPickingFrequency == true {
//                    isPickingFrequency = false
//                    tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Fade)
//                }
//                
//            case 3: break
//                
//            default: break
//            }
//        } else {
//            
//        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
