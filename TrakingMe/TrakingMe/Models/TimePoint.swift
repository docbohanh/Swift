//
//  TimePoint.swift
//  TrakingMe
//
//  Created by Thành Lã on 1/13/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import UIKit

struct TimePoint {
    var startTime: Double
    var addedTime: [Int]
    
    init(startTime: Double, addedTime: [Int]) {
        self.startTime = startTime
        self.addedTime = addedTime
    }
}


