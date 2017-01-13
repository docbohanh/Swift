//
//  TrackingInfo.swift
//  TrakingMe
//
//  Created by Thành Lã on 1/6/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import Foundation

class TrackingInfo {
    
    open let totalDistance: Double
    open let rawPath: String
    open let stopPoints: [StopPoint]
    open let gsmPoints: [GSMPoint]
    open let velocityPoints: [Int]
    open let timePoints: [TimeInterval]
    
    init(totalDistance: Double, rawPath: String, stopPoints: [StopPoint], gsmPoints: [GSMPoint], velocityPoints: [Int], timePoints: [TimeInterval]) {
        self.totalDistance  = totalDistance
        self.rawPath        = rawPath
        self.stopPoints     = stopPoints
        self.gsmPoints      = gsmPoints
        self.velocityPoints = velocityPoints
        self.timePoints     = timePoints
    }
}
