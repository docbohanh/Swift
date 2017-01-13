//
//  VehicleOnline.swift
//  TrakingMe
//
//  Created by Thành Lã on 1/13/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import UIKit
import GoogleMaps

public struct VehicleOnline {
    
    public var coordinate: CLLocationCoordinate2D
    public var speed: CGFloat
    public var vehicleTime: TimeInterval
    public var direction: CGFloat
    
    
    init(coordinate: CLLocationCoordinate2D,
         speed: CGFloat,
         vehicleTime: TimeInterval,
         direction: CGFloat) {
                
        self.coordinate  = coordinate
        self.speed     = speed
        self.vehicleTime = vehicleTime
        self.direction   = direction
    }
    
    init(tracking: Tracking) {
        self.coordinate  = tracking.movements[0].coordinate
        self.speed     = tracking.velocityPoints[0].velocity
        self.vehicleTime = tracking.movements[0].timestamp
        self.direction   = 0
    }
    
}
