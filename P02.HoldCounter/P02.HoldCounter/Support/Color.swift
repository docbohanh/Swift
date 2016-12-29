//
//  Color.swift
//  BAMapTools
//
//  Created by MILIKET on 7/7/16.
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
    
    /*----------------*/
    
    static var main: UIColor { return UIColor(rgba: "0087df") }//Màu xanh nhạt
    
    struct Navigation {
        
        static func backgroundColor() -> UIColor { return UIColor(rgba: "297FC8") }
        static func tintColor() -> UIColor { return UIColor.white }
        
        static func mainColor() -> UIColor { return UIColor(rgba: "297FC8") }   // Màu Xanh da trời 1D89E0
                
        static func subColor() -> UIColor { return UIColor(rgba: "FF783C") }    // Màu đỏ FF783C
        
        static func highLightTextColor() -> UIColor { return UIColor(rgba: "7bbbec") }
        
    }
    
    /**
     Màu nền cho các Text
     */
    struct Text {
        
        static func blackNormalColor() -> UIColor {return UIColor.black}
        
        static func whiteNormalColor() -> UIColor {return UIColor.white}
        
        static func grayNormalColor() -> UIColor {return UIColor(rgba: "6E6E6E")}
        
        static func blackMediumColor() -> UIColor { return UIColor.black.alpha(0.8)}
        
        static func grayMediumColor() -> UIColor { return UIColor.gray.alpha(0.8)}
        
        static func disableTextColor() -> UIColor { return UIColor.gray.alpha(0.8) }
        
        static func deselectedColor() -> UIColor {  return UIColor(red: 155/255.0, green: 155/255.0, blue: 155/255.0, alpha: 1.0)}
        
        
        static func subSidebarColor() -> UIColor { return UIColor(rgba: "FFFF00")}
     
        static func fromAddressColor() -> UIColor { return UIColor(rgba: "297FC8")}
       
        static func toAddressColor() -> UIColor {  return UIColor(rgba: "FF783C")}
        
        
        static func emptyColor() -> UIColor {  return UIColor.gray.alpha(0.7)}
        
    }
    struct SideBar {
        static func textColor() -> UIColor { return UIColor.white }
        
        static func selectedTextColor() -> UIColor { return UIColor.white }
        
        static func selectedBackgroundColor() -> UIColor { return UIColor.white.alpha(0.2) }
        
        
        static func headerBackgroundColor() -> UIColor { return UIColor(rgba: "1B2430") }
        
        static func cellBackgroundColor() -> UIColor { return UIColor(rgba: "1B2430") }
        
        
    }
    struct Misc {
        static func seperatorColor() -> UIColor { return UIColor(rgba: "DDD") }
    }
    /**
     Màu nền cho các Table
     */
    struct Table {
        static func tableEmptyColor() -> UIColor { return UIColor(rgba: "f5f7fa")}
        
        static func tablePlainColor() -> UIColor { return UIColor.white}
        
        static func tableGroupColor() -> UIColor { return UIColor(rgba: "#EFEFEF")}
        
        
        static var delete = UIColor(rgba: "FF5252")
        static var regard = UIColor(rgba: "297FC8")
    }
    
    
    /**
     Màu của segment trên bản đồ
     */
    struct Segment {
        
        static var lightGreen = UIColor(rgba: "64DD17")
        static var lightBlue = UIColor(rgba: "03A9F4")
        static var lime = UIColor(rgba: "C6FF00")
        static var blue = UIColor(rgba: "3e97fa")
        static var cyan = UIColor(rgba: "00BCD4")
        static var orange = UIColor(rgba: "#FF5722")
        static var pink = UIColor(rgba: "E91E63")
        static var amber = UIColor(rgba: "FFC107")
        static var yellowMedium = UIColor(rgba: "FFEB3B")
        
        static var newWay = UIColor(rgba: "b2ec5d") // Mau xanh
        static var highWay = UIColor(255, 0, 0)     // Màu đỏ
        static var provinWay = UIColor(220, 152, 0) // Màu cam
        static var majorWay = UIColor(197, 0, 255)  // Màu tím
        static var laneWay = UIColor(rgba: "5588FF")  // Màu xanh dương
        
        static var doneWay = UIColor(rgba: "FFEB3B")  // Màu vàng nhạt
        
        static var warning = UIColor(rgba: "D2691E") // Màu nâu
        
        
    }
    
    struct Tracking {
        static var general: UIColor { return UIColor(rgba: "68efad") }
        
    }
    
}

