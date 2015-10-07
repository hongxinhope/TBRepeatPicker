//
//  DemoViewController.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/30.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController, TBRepeatPickerDelegate {
    var recurrence: TBRecurrence?
    
    @IBOutlet weak var resultTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func startPicking(sender: UIButton) {
        let repeatPicker = TBRepeatPicker.initWith(NSLocale.currentLocale(), language: .SimplifiedChinese, tintColor: tbBlueColor())
        repeatPicker.delegate = self
        
        //recurrence = nil
        
        //recurrence = TBRecurrence.initDaily(1, locale:  NSLocale.currentLocale())
        
        //recurrence = TBRecurrence.initWeekly(1, selectedWeekdays: [], locale:  NSLocale.currentLocale())
        //recurrence = TBRecurrence.initWeekly(1, selectedWeekdays: [2, 2, 6], locale:  NSLocale.currentLocale())
        //recurrence = TBRecurrence.initWeekly(2, selectedWeekdays: [], locale:  NSLocale.currentLocale())
        //recurrence = TBRecurrence.initWeekly(2, selectedWeekdays: [1, 5], locale:  NSLocale.currentLocale())
        
        //recurrence = TBRecurrence.initMonthly(1, selectedMonthdays: [], locale: NSLocale.currentLocale())
        //recurrence = TBRecurrence.initMonthly(2, selectedMonthdays: [], locale: NSLocale.currentLocale())
        //recurrence = TBRecurrence.initMonthly(1, selectedMonthdays: [3, 17], locale: NSLocale.currentLocale())
        //recurrence = TBRecurrence.initMonthly(3, selectedMonthdays: [5, 20], locale: NSLocale.currentLocale())
        
        //recurrence = TBRecurrence.initMonthlyByWeekNumber(1, pickedWeekNumber: .Second, pickedWeekday: .Day, locale:  NSLocale.currentLocale())
        //recurrence = TBRecurrence.initMonthlyByWeekNumber(4, pickedWeekNumber: .Third, pickedWeekday: .Weekday, locale:  NSLocale.currentLocale())
        
        //recurrence = TBRecurrence.initYearly(1, selectedMonths: [], locale: NSLocale.currentLocale())
        //recurrence = TBRecurrence.initYearly(4, selectedMonths: [], locale: NSLocale.currentLocale())
        //recurrence = TBRecurrence.initYearly(1, selectedMonths: [3, 8], locale: NSLocale.currentLocale())
        //recurrence = TBRecurrence.initYearly(3, selectedMonths: [7, 9], locale: NSLocale.currentLocale())
        
        //recurrence = TBRecurrence.initYearlyByWeekNumber(1, pickedWeekNumber: .Fifth, pickedWeekday: .Wednesday, locale:  NSLocale.currentLocale())
        //recurrence = TBRecurrence.initYearlyByWeekNumber(3, pickedWeekNumber: .Last, pickedWeekday: .Day, locale:  NSLocale.currentLocale())
        
        repeatPicker.recurrence = recurrence
        
        navigationController?.pushViewController(repeatPicker, animated: true)
    }
    
    func didPickRecurrence(recurrence: TBRecurrence?) {
        self.recurrence = recurrence
        
        if let _ = recurrence {
            resultTextView.text = TBRPHelper.recurrenceString(recurrence!, language: .SimplifiedChinese, locale: NSLocale.currentLocale())
        } else {
            resultTextView.text = "永不重复"
        }
    }
    
    func tbBlueColor() -> UIColor {
        return UIColor.init(red: 3.0 / 255.0, green: 169.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
    }
}
