//
//  DemoViewController.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/30.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

let languageStrings = ["English", "SimplifiedChinese", "TraditionalChinese", "Korean", "Japanese"]
let languages: [TBRPLanguage] = [.English, .SimplifiedChinese, .TraditionalChinese, .Korean, .Japanese]

class DemoViewController: UIViewController, TBRepeatPickerDelegate, SwitchLanguageViewControllerDelegate {
    var startDate = NSDate()
    var recurrence: TBRecurrence?
    var language: TBRPLanguage = .English
    
    @IBOutlet weak var resultTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        startDate = dateFormatter.dateFromString("2015-09-14")! // 2015-09-14 Monday
        
        resultTextView.userInteractionEnabled = false
        updateLanguageTitle()
        updateResultTextView()
    }
    
    private func updateLanguageTitle() {
        let languageIndex = languages.indexOf(language)
        let languageTitle = languageStrings[languageIndex!]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: languageTitle, style: .Plain, target: self, action: "switchLanguage")
    }
    
    func switchLanguage() {
        let switchLanguageViewController = SwitchLanguageViewController.init(style: .Grouped)
        let navigationViewController = UINavigationController(rootViewController: switchLanguageViewController)
        switchLanguageViewController.language = language
        switchLanguageViewController.delegate = self
        
        presentViewController(navigationViewController, animated: true, completion: nil)
    }
    
    func donePickingLanguage(language: TBRPLanguage) {
        self.language = language
        updateLanguageTitle()
        updateResultTextView()
    }
    
    @IBAction func startPicking(sender: UIButton) {
        let repeatPicker = TBRepeatPicker.initPicker(startDate, language: language, tintColor: tbBlueColor())
        repeatPicker.delegate = self
        
//        recurrence = nil
//        
//        recurrence = TBRecurrence.initDaily(1, startDate: startDate)
//        
//        recurrence = TBRecurrence.initWeekly(1, selectedWeekdays: [], startDate: startDate)
//        recurrence = TBRecurrence.initWeekly(1, selectedWeekdays: [2, 2, 6], startDate: startDate)
//        recurrence = TBRecurrence.initWeekly(2, selectedWeekdays: [], startDate: startDate)
//        recurrence = TBRecurrence.initWeekly(2, selectedWeekdays: [1, 3, 5, 6, 0], startDate: startDate)
//        
//        recurrence = TBRecurrence.initMonthly(1, selectedMonthdays: [], startDate: startDate)
//        recurrence = TBRecurrence.initMonthly(2, selectedMonthdays: [], startDate: startDate)
//        recurrence = TBRecurrence.initMonthly(1, selectedMonthdays: [3, 17], startDate: startDate)
//        recurrence = TBRecurrence.initMonthly(3, selectedMonthdays: [5, 20], startDate: startDate)
//        
//        recurrence = TBRecurrence.initMonthlyByWeekNumber(1, pickedWeekNumber: .Second, pickedWeekday: .Day, startDate: startDate)
//        recurrence = TBRecurrence.initMonthlyByWeekNumber(4, pickedWeekNumber: .Third, pickedWeekday: .Weekday, startDate: startDate)
//        
//        recurrence = TBRecurrence.initYearly(1, selectedMonths: [], startDate: startDate)
//        recurrence = TBRecurrence.initYearly(4, selectedMonths: [], startDate: startDate)
//        recurrence = TBRecurrence.initYearly(1, selectedMonths: [3, 8], startDate: startDate)
//        recurrence = TBRecurrence.initYearly(3, selectedMonths: [7, 9], startDate: startDate)
//        
//        recurrence = TBRecurrence.initYearlyByWeekNumber(1, pickedWeekNumber: .Fifth, pickedWeekday: .Wednesday, startDate: startDate)
//        recurrence = TBRecurrence.initYearlyByWeekNumber(3, pickedWeekNumber: .Last, pickedWeekday: .Day, startDate: startDate)
//        
//        recurrence = TBRecurrence.dailyRecurrence(startDate)
//        recurrence = TBRecurrence.weeklyRecurrence(startDate)
//        recurrence = TBRecurrence.biWeeklyRecurrence(startDate)
//        recurrence = TBRecurrence.monthlyRecurrence(startDate)
//        recurrence = TBRecurrence.yearlyRecurrence(startDate)
//        recurrence = TBRecurrence.weekdayRecurrence(startDate)
        
        repeatPicker.recurrence = recurrence
        
        navigationController?.pushViewController(repeatPicker, animated: true)
    }
    
    func didPickRecurrence(recurrence: TBRecurrence?, repeatPicker: TBRepeatPicker) {
        self.recurrence = recurrence
        
        updateResultTextView()
    }
    
    private func updateResultTextView() {
        if let _ = recurrence {
            resultTextView.text = TBRPHelper.recurrenceString(recurrence!, startDate: startDate, language: language)
        } else {
            resultTextView.text = "Never Repeat"
        }
    }
    
    func tbBlueColor() -> UIColor {
        return UIColor.init(red: 3.0 / 255.0, green: 169.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
    }
}
