//
//  Image.swift
//  Dang
//
//  Created by Thành Lã on 12/30/16.
//  Copyright © 2016 IOS. All rights reserved.
//

import UIKit
import PHExtensions

extension UIImage {
    /**
     Vẽ ảnh từ text
     */
    class func imageFromText(_ text: String, size: CGSize, textSize: CGFloat = 24, color: UIColor = UIColor.main) -> UIImage {
        
        let data = text.data(using: String.Encoding.utf8, allowLossyConversion: true)
        let drawText = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        
        let textFontAttributes = [NSFontAttributeName: UIFont(name: FontType.latoSemibold.., size: textSize)!,
                                  NSForegroundColorAttributeName: color]
        
        let widthOfText = Utility.shared.widthForView(text: text, font: UIFont(name: FontType.latoSemibold.., size: textSize)!, height: size.height)
        let heightOfText = Utility.shared.heightForView(text: text, font: UIFont(name: FontType.latoSemibold.., size: textSize)!, width: size.width)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        drawText?.draw(in: CGRect(x: (size.width - widthOfText) / 2, y: (size.height - heightOfText) / 2, width: size.width, height: size.height),
                       withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func tint(_ color:UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        color.set()
        UIRectFill(rect)
        draw(in: rect, blendMode: CGBlendMode.destinationIn, alpha: CGFloat(1.0))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

}

struct Icon {
    
    struct Home {
        static var SearchHistory = UIImage(named: "SearchHistory")!
        static var Calendar = UIImage(named: "Calendar")!
        static var Time = UIImage(named: "Time")!
        static var Personal = UIImage(named: "Personal")!
        static var VehicleCar = UIImage(named: "VehicleCar")!
        static var Favorite = UIImage(named: "Favorite")!
        static var FavoriteFill = UIImage(named: "FavoriteFill")!
        static var markerCenter = UIImage(named: "MarkerCenter")!
        
    }
    
    struct General {
        static var myLocation = UIImage(named: "MyLocation")!
        static var arrowDown = UIImage(named: "ArrowDown")!
    }
    
    struct Person {
        static var avatar = UIImage(named: "avatar")!
    }
    
    struct Nav {
        
        static var Menu     = UIImage(named: "Menu")!
        static var Back     = UIImage(named: "Back")!
        static var Done     = UIImage(named: "Done")!
        static var Trash    = UIImage(named: "Trash")!
        static var Delete   = UIImage(named: "Delete")!
        static var Add      = UIImage(named: "Add")!
        static var Filter   = UIImage(named: "Filter")!
        static var Refesh   = UIImage(named: "Refesh")!
        static var Arrow    = UIImage(named: "Arrow")!
        
        static var edit     = UIImage(named: "Edit")!
        static var setting  = UIImage(named: "Setting")!
        static var info     = UIImage(named: "Info")!
    }
    
    struct Marker {
        static var active = UIImage(named: "active")!
        static var inActive = UIImage(named: "inActive")!
    }
    
    struct Tracking {
        static var empty = UIImage(named: "empty")!
        static var arrow = UIImage(named: "Arrow")!
        static var map   = UIImage(named: "trackingMap")!
        static var start = UIImage(named: "Start")!
        static var stop  = UIImage(named: "Stop")!
        static var end   = UIImage(named: "End")!
        static var car   = UIImage(named: "Car")!
        
        static var avatar   = UIImage(named: "avatar")!
        
        static var Start: UIImage { return UIImage(named: "Start")! }
        
        static var End: UIImage { return UIImage(named: "End")! }
        
        static var Arrow: UIImage { return UIImage(named: "Arrow")! }
        
        static var Stop: UIImage { return UIImage(named: "Stop")! }
        
        static var Distance: UIImage { return UIImage(named: "Distance")! }
        
        static var LostGPS: UIImage { return UIImage(named: "LostGPS")! }
        
        static var ReceivedGPS: UIImage { return UIImage(named: "ReceivedGPS")! }
        
        static var LostGSM: UIImage { return UIImage(named: "LostGSM")! }
        
        static var ReceivedGSM: UIImage { return UIImage(named: "ReceivedGSM")! }
        
        static var Play: UIImage { return UIImage(named: "Play")! }
        
        static var Pause: UIImage { return UIImage(named: "Pause")! }
        
        static var TrackingCar: UIImage { return UIImage(named: "TrackingCar")! }
        
        static var ArrowRight: UIImage { return UIImage(named: "Tracking_ArrowRight")! }
    }
    

}
