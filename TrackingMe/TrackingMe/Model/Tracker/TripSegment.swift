//
//  TripSegment.swift
//  TrakingMe
//
//  Created by Thành Lã on 1/6/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

public struct LineSegment {
    
    public enum Category: Int {
        case unknown   = 0
        case stop      = 1
        case normal    = 2
        case highSpeed = 3
        case speeding  = 4
        case noSignal  = 5
    }
    
    public let startIndex: Int
    public let endIndex: Int
    public let category: Category
    
    public init(startIndex: Int, endIndex: Int, category: Category) {
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.category = category
    }
}

public struct StopPoint {
    
    public enum Category: Int {
        case unknown     = 0
        case drawVehicle = 1
        case drawPoint   = 2
        case drawPath    = 3
        
    }
    public let startIndex: Int
    public let endIndex: Int
    public let time: TimeInterval
    public let duration: TimeInterval
    public let category: Category
    
    public init(startIndex: Int, endIndex: Int, category: Category, time: TimeInterval, duration: TimeInterval) {
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.time = time
        self.duration = duration
        self.category = category
    }
}

public struct GSMPoint {
    public let startIndex: Int
    public let endIndex: Int
    public let time: TimeInterval
    public let duration: TimeInterval
    
    public init(startIndex: Int, endIndex: Int, time: TimeInterval, duration: TimeInterval) {
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.time = time
        self.duration = duration
    }
}
