//
//  UIColor+TBRPAddition.swift
//  TBRepeatPicker
//
//  Created by 洪鑫 on 15/10/9.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

extension UIColor {
    var rgbComponents:(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var redValue:CGFloat = 0
        var greenValue:CGFloat = 0
        var blueValue:CGFloat = 0
        var alphaValue:CGFloat = 0
        
        getRed(&redValue, green: &greenValue, blue: &blueValue, alpha: &alphaValue)
        
        let bit: CGFloat = 255.0
        redValue *= bit
        greenValue *= bit
        blueValue *= bit
        
        return (redValue, greenValue, blueValue, alphaValue)
    }
}
