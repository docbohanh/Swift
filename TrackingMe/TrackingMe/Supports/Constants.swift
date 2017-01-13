//
//  Constants.swift
//  P01.TapCounter
//
//  Created by Thành Lã on 12/28/16.
//  Copyright © 2016 Bình Anh Electonics. All rights reserved.
//

import UIKit

/**
 Enum Font Size cho text
 */
enum FontSize: CGFloat {
    case small  = 12
    case normal = 15
    case large  = 18
}

/**
 Các loại Font hiển thị trên Iphone
 */
enum FontType: String {
    case latoRegular        = "Lato-Regular"
    case latoMedium         = "Lato-Medium"
    case latoSemibold       = "Lato-Semibold"
    case latoLight          = "Lato-Light"
    case latoBold           = "Lato-Bold"
    case latoBlackItalic    = "Lato-BlackItalic"
    case latoItalic         = "Lato-Italic"
}

enum AppNotification: String {
    case SaveTrackingSignal = "save_tracking"
}
