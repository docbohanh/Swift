//
//  GPSLostMarker.swift
//  GPSMobile
//
//  Created by Nguyen Duc Nang on 4/21/16.
//  Copyright © 2016 Hoan Pham. All rights reserved.
//


import UIKit
import PHExtensions
import GoogleMaps
//import GPSNetwork

class GPSLostMarker: GMSMarker {
    
    enum Status {
        case lost
        case received
    }

    
    init(status: Status, position: CLLocationCoordinate2D) {
        super.init()
        self.position = position
        self.tracksViewChanges = false
        self.isTappable = false
        
        switch status {
        case .lost:
            self.icon = Icon.Tracking.LostGPS
        default:
            self.icon = Icon.Tracking.ReceivedGPS
        }
        
        
        self.groundAnchor = CGPoint(x: 0.5, y: 1.0)
    }
}

