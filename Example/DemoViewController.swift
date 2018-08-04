//
//  DemoViewController.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/30.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

let languageStrings = ["English", "SimplifiedChinese", "TraditionalChinese", "Korean", "Japanese"]
let languages: [TBRPLanguage] = [.english, .simplifiedChinese, .traditionalChinese, .korean, .japanese]

class DemoViewController: UIViewController, TBRepeatPickerDelegate, SwitchLanguageViewControllerDelegate {
    var occurrenceDate = Date()
    var recurrence: TBRecurrence?
    var language: TBRPLanguage = .english
    
    @IBOutlet weak var resultTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        occurrenceDate = dateFormatter.dateFromString("2015-09-14")! // 2015-09-14 Monday
        
        resultTextView.isUserInteractionEnabled = false
        updateLanguageTitle()
        updateResultTextView()
    }
    
    fileprivate func updateLanguageTitle() {
        let languageIndex = languages.index(of: language)
        let languageTitle = languageStrings[languageIndex!]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: languageTitle, style: .plain, target: self, action: #selector(DemoViewController.switchLanguage))
    }
    
    @objc func switchLanguage() {
        let switchLanguageViewController = SwitchLanguageViewController.init(style: .grouped)
        let navigationViewController = UINavigationController(rootViewController: switchLanguageViewController)
        switchLanguageViewController.language = language
        switchLanguageViewController.delegate = self
        
        present(navigationViewController, animated: true, completion: nil)
    }
    
    func donePickingLanguage(_ language: TBRPLanguage) {
        self.language = language
        updateLanguageTitle()
        updateResultTextView()
    }
    
    @IBAction func startPicking(_ sender: UIButton) {
        let repeatPicker = TBRepeatPicker.initPicker(occurrenceDate, language: language, tintColor: tbBlueColor())
        repeatPicker.delegate = self
        
//        recurrence = nil
//        
//        recurrence = TBRecurrence.initDaily(1, occurrenceDate: occurrenceDate)
//        
//        recurrence = TBRecurrence.initWeekly(1, selectedWeekdays: [], occurrenceDate: occurrenceDate)
//        recurrence = TBRecurrence.initWeekly(1, selectedWeekdays: [2, 2, 6], occurrenceDate: occurrenceDate)
//        recurrence = TBRecurrence.initWeekly(2, selectedWeekdays: [], occurrenceDate: occurrenceDate)
//        recurrence = TBRecurrence.initWeekly(2, selectedWeekdays: [1, 3, 5, 6, 0], occurrenceDate: occurrenceDate)
//        
//        recurrence = TBRecurrence.initMonthly(1, selectedMonthdays: [], occurrenceDate: occurrenceDate)
//        recurrence = TBRecurrence.initMonthly(2, selectedMonthdays: [], occurrenceDate: occurrenceDate)
//        recurrence = TBRecurrence.initMonthly(1, selectedMonthdays: [3, 17], occurrenceDate: occurrenceDate)
//        recurrence = TBRecurrence.initMonthly(3, selectedMonthdays: [5, 20], occurrenceDate: occurrenceDate)
//        
//        recurrence = TBRecurrence.initMonthlyByWeekNumber(1, pickedWeekNumber: .Second, pickedWeekday: .Day, occurrenceDate: occurrenceDate)
//        recurrence = TBRecurrence.initMonthlyByWeekNumber(4, pickedWeekNumber: .Third, pickedWeekday: .Weekday, occurrenceDate: occurrenceDate)
//        
//        recurrence = TBRecurrence.initYearly(1, selectedMonths: [], occurrenceDate: occurrenceDate)
//        recurrence = TBRecurrence.initYearly(4, selectedMonths: [], occurrenceDate: occurrenceDate)
//        recurrence = TBRecurrence.initYearly(1, selectedMonths: [3, 8], occurrenceDate: occurrenceDate)
//        recurrence = TBRecurrence.initYearly(3, selectedMonths: [7, 9], occurrenceDate: occurrenceDate)
//        
//        recurrence = TBRecurrence.initYearlyByWeekNumber(1, pickedWeekNumber: .Fifth, pickedWeekday: .Wednesday, occurrenceDate: occurrenceDate)
//        recurrence = TBRecurrence.initYearlyByWeekNumber(3, pickedWeekNumber: .Last, pickedWeekday: .Day, occurrenceDate: occurrenceDate)
//        
//        recurrence = TBRecurrence.dailyRecurrence(occurrenceDate)
//        recurrence = TBRecurrence.weeklyRecurrence(occurrenceDate)
//        recurrence = TBRecurrence.biWeeklyRecurrence(occurrenceDate)
//        recurrence = TBRecurrence.monthlyRecurrence(occurrenceDate)
//        recurrence = TBRecurrence.yearlyRecurrence(occurrenceDate)
//        recurrence = TBRecurrence.weekdayRecurrence(occurrenceDate)
        
        repeatPicker.recurrence = recurrence
        
        navigationController?.pushViewController(repeatPicker, animated: true)
    }
    
    func didPickRecurrence(_ recurrence: TBRecurrence?, repeatPicker: TBRepeatPicker) {
        self.recurrence = recurrence
        
        updateResultTextView()
    }
    
    fileprivate func updateResultTextView() {
        if let _ = recurrence {
            resultTextView.text = TBRPHelper.recurrenceString(recurrence!, occurrenceDate: occurrenceDate, language: language)
        } else {
            resultTextView.text = "Never Repeat"
        }
    }
    
    func tbBlueColor() -> UIColor {
        return UIColor.init(red: 3.0 / 255.0, green: 169.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
    }
}
