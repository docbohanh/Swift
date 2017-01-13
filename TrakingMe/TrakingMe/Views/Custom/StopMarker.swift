//
//  StopMarker.swift
//  TrakingMe
//
//  Created by Thành Lã on 1/6/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import UIKit
import PHExtensions
import GoogleMaps

class StopMarker: GMSMarker, InspectableMarker {
    
    
    fileprivate enum Size: CGFloat {
        case width = 70, height = 50
    }
    
    let info: TrackingStopPoint
    
    init(position: CLLocationCoordinate2D, info: TrackingStopPoint) {
        self.info = info
        super.init()
        self.position = position
        self.tracksViewChanges = false
        self.isTappable = true
        self.icon = Icon.Tracking.Stop
        self.groundAnchor = CGPoint(x: 0.5, y: 0.5)
    }
}
