//
//  ArrowMarker.swift
//  GPSMobile
//
//  Created by Nguyen Duc Nang on 4/19/16.
//  Copyright © 2016 Hoan Pham. All rights reserved.
//


import UIKit
import PHExtensions
import GoogleMaps
//import GPSNetwork

class ArrowMarker: GMSMarker {
    
    
    fileprivate enum Size: CGFloat {
        case width = 70, height = 50
    }
    
    init(position: CLLocationCoordinate2D, direction: CLLocationDirection) {
        super.init()
        self.position = position
        self.rotation = direction
        self.tracksViewChanges = false
        self.isTappable = false
        self.icon = Icon.Tracking.arrow.tint(UIColor.orange.alpha(0.8))
        self.groundAnchor = CGPoint(x: 0.5, y: 0.5)
    }
}

