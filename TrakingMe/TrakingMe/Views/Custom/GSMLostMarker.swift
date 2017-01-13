//
//  GSMLostMarker.swift
//  GPSMobile
//
//  Created by Nguyen Duc Nang on 4/21/16.
//  Copyright © 2016 Hoan Pham. All rights reserved.
//


import UIKit
import PHExtensions
import GoogleMaps
//import GPSNetwork

class GSMLostMarker: GMSMarker, InspectableMarker {
    
    enum Status {
        case lost
        case received
    }
    
    let info: TrackingGSMPoint
    
    let status: Status
    
    init(status: Status, position: CLLocationCoordinate2D, info: TrackingGSMPoint) {
        self.info = info
        self.status = status
        super.init()
        self.position = position
        self.tracksViewChanges = false
        self.isTappable = true
        
        switch status {
        case .lost:
            self.icon = Icon.Tracking.LostGSM
        default:
            self.icon = Icon.Tracking.ReceivedGSM
        }
        
        
        self.layer.cornerRadius = self.icon!.size.height / 2
        self.layer.masksToBounds = true
        
        self.groundAnchor = CGPoint(x: 0.5, y: 1.0)
    }
}

