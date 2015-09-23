//
//  TBRepeatPicker.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/23.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

class TBRepeatPicker: UIViewController  {
    // MARK: - Public properties
    
    // MARK: - Private properties
    
    // MARK: - Public functions
    convenience init(locale: NSLocale?, tintColor: UIColor?) {
        self.init()
        
        let presetRepeatController = TBRPPresetRepeatController(style: .Grouped)
        if let locale = locale {
            presetRepeatController.locale = locale
        }
        if let tintColor = tintColor {
            presetRepeatController.tintColor = tintColor
        }
        presetRepeatController.selectedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        
        let navigationViewController = UINavigationController.init(rootViewController: presetRepeatController)
        navigationViewController.willMoveToParentViewController(self)
        self.view.addSubview(navigationViewController.view)
        self.addChildViewController(navigationViewController)
        navigationViewController.didMoveToParentViewController(self)
    }
    
    // MARK: - Private functions
    
}
