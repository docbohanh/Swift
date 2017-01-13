//
//  TrackingInfo.swift
//  TrakingMe
//
//  Created by Thành Lã on 1/6/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import UIKit
import GoogleMaps

class TrackingInfo {
    let totalKm: CGFloat
    let directionDetail: String
    let stopPointList: [StopPoint]
    let velocityPointList: [VelocityPoint]
    let timePoint: TimePoint
    let gsmPoint: [GSMPoint]
    
    init(totalKm: CGFloat, directionDetail: String, stopPointList: [StopPoint], velocityPointList: [VelocityPoint], timePoint: TimePoint, gsmPoint: [GSMPoint]) {
        
        self.totalKm  = totalKm
        self.directionDetail = directionDetail
        self.stopPointList = stopPointList
        self.velocityPointList = velocityPointList
        self.timePoint = timePoint
        self.gsmPoint = gsmPoint
    }
    
    init(tracking: Tracking) {
        
        self.totalKm            = CGFloat(tracking.totalKm)
        self.directionDetail    = Utility.shared.getGMSPath(from: tracking.coordinates).encodedPath()
        self.stopPointList      = []
        self.velocityPointList  = tracking.velocityPoints
        self.timePoint          = TimePoint(startTime: tracking.movements[0].timestamp, addedTime: tracking.times.map { Int($0) })
        self.gsmPoint           = []
    }
}
