//
//  SwitchLanguageViewController.swift
//  TBRepeatPicker
//
//  Created by 洪鑫 on 15/10/9.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

private let SwitchLanguageViewControllerCellID = "SwitchLanguageViewControllerCell"

protocol SwitchLanguageViewControllerDelegate {
    func donePickingLanguage(language: TBRPLanguage)
}

class SwitchLanguageViewController: UITableViewController {
    var language: TBRPLanguage = .English
    var delegate: SwitchLanguageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelPressed")
    }
    
    func cancelPressed() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(SwitchLanguageViewControllerCellID)
        if cell == nil {
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: SwitchLanguageViewControllerCellID)
        }

        cell?.textLabel?.text = languageStrings[indexPath.row]
        
        if language == languages[indexPath.row] {
            cell?.accessoryType = .Checkmark
        } else {
            cell?.accessoryType = .None
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        language = languages[indexPath.row]
        tableView.reloadData()
        
        if let _ = delegate {
            dismissViewControllerAnimated(true, completion: { () -> Void in
                delegate?.donePickingLanguage(language)
            })
        }
    }

}
