//
//  DemoViewController.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/30.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {
    @IBOutlet weak var resultTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func startPicking(sender: UIButton) {
        let repeatPicker = TBRepeatPicker(locale: NSLocale.currentLocale(), language: .SimplifiedChinese, tintColor: tbBlueColor())
        navigationController?.pushViewController(repeatPicker, animated: true)
    }
    
    
    func tbBlueColor() -> UIColor {
        return UIColor.init(red: 3.0 / 255.0, green: 169.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
    }
}
