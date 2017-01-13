//
//  TrackingStopPoint.swift
//  TrakingMe
//
//  Created by Thành Lã on 1/6/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import Foundation
import PHExtensions
import CoreLocation

struct TrackingStopPoint {
    let startIndex: Int
    let endIndex: Int
    let time: TimeInterval
    let duration: TimeInterval
    let category: StopPoint.Category
    let startCoordinate: Coordinate
    let endCoordinate: Coordinate
    
    init(startIndex: Int, startCoordinate: Coordinate, endIndex: Int, endCoordinate: Coordinate, category: StopPoint.Category, time: TimeInterval, duration: TimeInterval) {
        self.startCoordinate = startCoordinate
        self.endCoordinate   = endCoordinate
        self.startIndex      = startIndex
        self.endIndex        = endIndex
        self.time            = time
        self.duration        = duration
        self.category        = category
    }
}
