//
//  Color.swift
//  BAMapTools
//
//  Created by Thành Lã on 7/7/16.
//  Copyright © 2016 Binh Anh. All rights reserved.
//

import UIKit

extension UIColor {
    
    func alpha(_ alpha: CGFloat) -> UIColor {
        return self.withAlphaComponent(alpha)
    }
        
    convenience init(_ r: Int, _ g: Int, _ b: Int, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat(Double(r)/255.0),
            green: CGFloat(Double(g)/255),
            blue: CGFloat(Double(b)/255),
            alpha: alpha)
    }
    
    convenience init(rgba: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        let formattedCode = rgba.replacingOccurrences(of: "#", with: "")
        let formattedCodeLength = formattedCode.characters.count
        if formattedCodeLength != 3 && formattedCodeLength != 4 && formattedCodeLength != 6 && formattedCodeLength != 8 {
            fatalError("invalid color")
        }
        
        var hexValue: UInt32 = 0
        if Scanner(string: formattedCode).scanHexInt32(&hexValue) {
            switch formattedCodeLength {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
//    static var main: UIColor { return UIColor(rgba: "297FC8")  }//Màu xanh duong
    static var main: UIColor { return UIColor(rgba: "88B04B")  } // Màu xanh greenery
    
    static var button: UIColor { return UIColor(rgba: "00e8e2") }
    
    static var tracking: UIColor { return UIColor(rgba: "5588FF") }
    
}

