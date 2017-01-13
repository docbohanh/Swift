//
//  TrackingSegment.swift
//  TrakingMe
//
//  Created by Thành Lã on 1/6/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import UIKit

func == (l: TrackingSegment, r: TrackingSegment) -> Bool {
    switch (l.value, r.value) {
    case (.fixedValue(let x), .fixedValue(let y)):
        return x == y
        
    case (.rangeValue(let x1, let x2), .rangeValue(let y1, let y2)):
        return x1 == y1 && x2 == y2
        
    default:
        return false
    }
}

struct TrackingSegment: Equatable {
    
    enum SegmentValue {
        case fixedValue(TimeInterval)
        case rangeValue(TimeInterval, TimeInterval)
    }
    
    let index: Int
    let title: String
    let value: SegmentValue
    
    init(index: Int, title: String, value: SegmentValue) {
        self.index = index
        self.title = title
        self.value = value
    }
}

extension LineSegment.Category {
    func toColor() -> UIColor {
        
        switch self {
        case .normal:
            return UIColor.main // Xanh dương
            
        case .noSignal:
            return UIColor(rgba: "6695B8") // Lơ xanh
            
        case .highSpeed:
            return UIColor(rgba: "FF7145") //  Cam
            
        case .speeding:
            return UIColor(rgba: "E52D2D") // đỏ
            
        case .stop:
            return UIColor(rgba: "898989") // Xám
            
        case .unknown:
            return UIColor.black
        }
    }
}
