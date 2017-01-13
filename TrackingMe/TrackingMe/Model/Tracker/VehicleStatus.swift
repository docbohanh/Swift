//
//  VehicleStatus.swift
//  TrakingMe
//
//  Created by Thành Lã on 1/6/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import Foundation
public struct VehicleStatus : OptionSet, CustomStringConvertible {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }
    
    
    public static let None              = VehicleStatus(rawValue: 0)
    //    public static let HaveCustomer       = VehicleStatus(rawValue: (1 << 0 | 1 << 1)) // & 3
    public static let EngineOff         = VehicleStatus(rawValue: 1 << 3)// & 8
    public static let DoorOpen          = VehicleStatus(rawValue: 1 << 4)// & 16
    public static let AirConditionerOff = VehicleStatus(rawValue: 1 << 5)// & 32
    public static let OnTrip            = VehicleStatus(rawValue: 1 << 10)// 1024
    
    public var mixingConcrete: Bool {
        return rawValue & ( 1 << 14 | 1 << 15) == 1 << 14 ? true : false // & 49152 == 16384
    }
    
    public var disposingConcrete: Bool {
        return rawValue & ( 1 << 14 | 1 << 15) == 1 << 15 ? true : false // & 49152 == 32768
    }
    
    public var stoppedConcrete: Bool {
        let concreteStatus = ( 1 << 14 | 1 << 15)
        return rawValue & concreteStatus != 1 << 14
            && rawValue & concreteStatus != 1 << 15
            ? true : false // & 49152 == 32768
    }
    
    public var description: String {
        
        var string = String()
        
        if self.contains(.EngineOff) {
            string += "Xe đang dừng đỗ"
        }
        else {
            string += "Xe đang di chuyển"
        }
        
        string += ", "
        
        if self.contains(.DoorOpen) {
            string += "mở cửa"
        }
        else {
            string += "đóng cửa"
        }
        
        string += ", "
        
        if self.contains(.AirConditionerOff) {
            string += "tắt điều hòa"
        }
        else {
            string += "bật điều hòa"
        }
        
        return string
    }
}

public enum VehicleIcon: Int {
    case none   = 0
    case truck  = 1
    case bus    = 3
    case car    = 4
    case boat   = 5
    case taxi   = 6
    case rescue = 7
    case oldCar = 8
    case train  = 9
    case other  = 10
}

public enum VehicleColor {
    case stop // xám
    case normalSpeed // xanh
    case highSpeed // cam
    case speeding // đỏ
    case extendedStop // đỗ lâu -> xám + sao
    case lostGPS //icon cột sóng
    case lostGSM //icon warning
}
