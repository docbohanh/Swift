//
//  DirectionPoint.swift
//  TrakingMe
//
//  Created by Thành Lã on 12/31/16.
//  Copyright © 2016 Bình Anh Electonics. All rights reserved.
//

import Foundation
import PHExtensions
import CoreLocation

func == (l: DirectionPoint, r: DirectionPoint) -> Bool {
    let phi = abs (l.direction - r.direction).truncatingRemainder(dividingBy: 360)
    return (phi > 180 ? 360 - phi : phi) <= 30
}

struct DirectionPoint: Equatable {
    let coordinate: Coordinate
    let direction: CLLocationDirection
    
    init(coordinate: Coordinate, direction: CLLocationDirection) {
        self.coordinate = coordinate
        self.direction = direction
    }
}

