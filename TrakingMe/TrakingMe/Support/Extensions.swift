//
//  Extensions.swift
//  TrakingMe
//
//  Created by Thành Lã on 12/30/16.
//  Copyright © 2016 Bình Anh Electonics. All rights reserved.
//


import UIKit
import RealmSwift
import GoogleMaps
import PHExtensions

extension Results {
    func toArray() -> [Results.Iterator.Element] {
        return Array(self)
    }
}

extension GMSPath {
    
    var coordinates: [CLLocationCoordinate2D] {
        return (0..<self.count()).map { self.coordinate(at: $0) }
    }
}

extension Double {
    var toKmh: Double {
        return self * 3.6
    }
    
    var toHours: Double {
        return self / 3_600
    }
}
