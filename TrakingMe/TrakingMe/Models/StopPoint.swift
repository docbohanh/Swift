//
//  StopPoint.swift
//  TrakingMe
//
//  Created by Thành Lã on 1/13/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

struct StopPoint {
    var startIndex: Int
    var endIndex: Int
    var startTime: Double
    var duration: Int
    
    init(startIndex: Int, endIndex: Int, startTime: Double, duration: Int) {
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.startTime = startTime
        self.duration = duration
    }
}


struct TrackingStopPoint {
    let startIndex: Int
    let endIndex: Int
    let time: TimeInterval
    let duration: TimeInterval
    let startCoordinate: CLLocationCoordinate2D
    let endCoordinate: CLLocationCoordinate2D
    
    init(startIndex: Int, startCoordinate: CLLocationCoordinate2D, endIndex: Int, endCoordinate: CLLocationCoordinate2D, time: TimeInterval, duration: TimeInterval) {
        self.startCoordinate = startCoordinate
        self.endCoordinate   = endCoordinate
        self.startIndex      = startIndex
        self.endIndex        = endIndex
        self.time            = time
        self.duration        = duration
    }
}
