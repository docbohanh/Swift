//
//  TrackingSegment.swift
//  TrakingMe
//
//  Created by Thành Lã on 1/6/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import UIKit

extension VehicleIcon {
    var name: String {
        switch self {
        case .truck:    return "truck"
        case .bus:      return "bus"
        case .car:      return "car"
        case .boat:     return "boat"
        case .taxi:     return "taxi"
        case .rescue:   return "rescue"
        case .oldCar:   return "car"
        case .train:    return "train"
        default:        return ""
        }
    }
}

extension VehicleColor {
    var name: String {
        switch self {
        case .stop: return "grey"
        case .normalSpeed: return "blue"
        case .highSpeed: return "orange"
        case .speeding: return "red"
        case .extendedStop: return "stop"
        case .lostGPS: return "lost_gps"
        case .lostGSM: return "warn"
        }
    }
}
extension VehicleUpdate {
    
    var iconColor: VehicleColor {
        
        if let fake = self.fakeColor {
            return fake
        }
        
        /**
         *  29/4/2016: Sửa theo cách check của TrungTQ
         */
        
        /**
         *  TH1: Vehicle time mất > 150 phút -> mất GSM
         */
        if Date().timeIntervalSince1970 + 7.hours - vehicleTime > CompanyConfiguration.instance.DefaultTimeLossConnect.minutes { return .lostGSM }

        
        /**
         *  TH2: GPS Time mất > 150 phút -> mất GSM
         *  GPS Time mất > 5 phút -> mất GPS
         */
        if vehicleTime - updateTime > CompanyConfiguration.instance.DefaultMaxTimeLossGPS.minutes { return .lostGSM }
        if vehicleTime - updateTime > CompanyConfiguration.instance.DefaultMinTimeLossGPS.minutes { return .lostGPS }
        
        if status.contains(.EngineOff) { return .stop }
        else {
            if velocity > CompanyConfiguration.instance.DefaultMaxVelocityOrange { return .speeding }
            if velocity > CompanyConfiguration.instance.DefaultMaxVelocityBlue { return .highSpeed }
            
            return .normalSpeed
        }
    }
    
    var lostGSM: Bool {
        return (Date().timeIntervalSince1970 + 7.hours - vehicleTime > CompanyConfiguration.instance.DefaultTimeLossConnect.minutes) ||
        (vehicleTime - updateTime > CompanyConfiguration.instance.DefaultMaxTimeLossGPS.minutes) ? true : false
    }
    
    var lostGPS: Bool {
        return vehicleTime - updateTime > CompanyConfiguration.instance.DefaultMinTimeLossGPS.minutes ? true : false
    }
    
    func getVehicleImage() -> UIImage {
        
        if iconColor == .lostGPS {
            return UIImage(named: iconColor.name) ?? Icon.Tracking.car
        }
        
        return UIImage(named: self.iconCode.name + "_" + self.iconColor.name + "_0") ?? Icon.Tracking.car
    }
}
