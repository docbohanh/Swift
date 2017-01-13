//
//  PointMarker.swift
//  TrakingMe
//
//  Created by Thành Lã on 1/6/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import UIKit
import PHExtensions
import GoogleMaps

class PointMarker: GMSMarker {
    
    enum MarkerType {
        case start
        case end
    }
    
    init(status: MarkerType, position: CLLocationCoordinate2D) {
        super.init()
        self.position = position
        self.tracksViewChanges = false
        self.isTappable = false
        
        switch status {
        case .start:
            self.icon = Icon.Tracking.Start
        default:
            self.icon = Icon.Tracking.End
        }
        
        self.groundAnchor = CGPoint(x: 0.5, y: 1.0)
    }
}
