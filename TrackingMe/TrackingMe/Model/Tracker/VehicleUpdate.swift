//
//  VehicleUpdate.swift
//  TrakingMe
//
//  Created by Thành Lã on 1/6/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import CoreLocation

public func == (l: VehicleUpdate, r: VehicleUpdate) -> Bool {
    return l.ID == r.ID
}

public func > (l: VehicleUpdate, r: VehicleUpdate) -> Bool {
    switch (l.lostGSM, r.lostGSM) {
    case (true, true), (false, false): break
    case (true, false): return true
    case (false, true): return false
    }
    return l.privateCode > r.privateCode ? true : l.plate > r.plate ? true : false
}

public func >= (l: VehicleUpdate, r: VehicleUpdate) -> Bool {
    switch (l.lostGSM, r.lostGSM) {
    case (true, true), (false, false): break
    case (true, false): return true
    case (false, true): return false
    }
    
    return l.privateCode >= r.privateCode ? true : l.plate >= r.plate ? true : false
}

public func < (l: VehicleUpdate, r: VehicleUpdate) -> Bool {
    switch (l.lostGSM, r.lostGSM) {
    case (true, true), (false, false): break
    case (true, false): return false
    case (false, true): return true
    }
    return l.privateCode < r.privateCode ? true : l.plate < r.plate ? true : false
}

public func <= (l: VehicleUpdate, r: VehicleUpdate) -> Bool {
    switch (l.lostGSM, r.lostGSM) {
    case (true, true), (false, false): break
    case (true, false): return false
    case (false, true): return true
    }
    return l.privateCode <= r.privateCode ? true : l.plate <= r.plate ? true : false
}

public typealias RealTimeVehicle = VehicleUpdate

open class VehicleUpdate: CustomStringConvertible, Comparable {
    open let ID: Int64
    open let plate: String
    open let coordinate: CLLocationCoordinate2D
    open let status: VehicleStatus
    open let velocity: Int
    open let driverName: String
    open let driverPhone: String
    open let direction: CLLocationDirection
    open let updateTime: TimeInterval
    open let vehicleTime: TimeInterval
    open let iconCode: VehicleIcon
    open let privateCode: String
    
    public init(ID: Int64, plate: String, coordinate: CLLocationCoordinate2D, status: VehicleStatus, velocity: Int, driverName: String, driverPhone: String, direction: CLLocationDegrees, updateTime: TimeInterval, vehicleTime: TimeInterval, iconCode: VehicleIcon, privateCode: String) {
        self.ID          = ID
        self.coordinate  = coordinate
        self.status      = status
        self.velocity    = velocity
        self.driverName  = driverName
        self.driverPhone = driverPhone
        self.direction   = direction
        self.plate       = plate
        self.iconCode    = iconCode
        self.updateTime  = updateTime
        self.vehicleTime = vehicleTime
        self.privateCode = privateCode
    }
    
    public init(updateInfo: VehicleUpdate, direction: CLLocationDirection) {
        self.ID          = updateInfo.ID
        self.coordinate  = updateInfo.coordinate
        self.status      = updateInfo.status
        self.velocity    = updateInfo.velocity
        self.driverName  = updateInfo.driverName
        self.driverPhone = updateInfo.driverPhone
        self.direction   = direction
        self.plate       = updateInfo.plate
        self.iconCode    = updateInfo.iconCode
        self.updateTime  = updateInfo.updateTime
        self.vehicleTime = updateInfo.vehicleTime
        self.privateCode = updateInfo.privateCode
    }
    
    open var fakeColor: VehicleColor?
    
    open var description: String {
        return "Vehicle Update: plate: \(plate) - status: \(status) - driver: \(driverName) | \(driverPhone)"
    }
}
