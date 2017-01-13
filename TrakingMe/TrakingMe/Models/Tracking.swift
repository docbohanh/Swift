//
//  Tracking.swift
//  TrakingMe
//
//  Created by Thành Lã on 12/30/16.
//  Copyright © 2016 Bình Anh Electonics. All rights reserved.
//

import Foundation
import PHExtensions
import CleanroomLogger
import GoogleMaps

public struct Movement {
    let coordinate: Coordinate
    let timestamp: TimeInterval
    
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees, timestamp: TimeInterval) {
        self.coordinate = Coordinate(latitude: latitude, longitude: longitude)
        self.timestamp = timestamp
    }
    
    
    init(coordinate: Coordinate, timestamp: TimeInterval) {
        self.coordinate = coordinate
        self.timestamp = timestamp
    }
}

public struct Tracking {
    let id: String
    let name: String
    var movements: [Movement]
    
    init(id: String, name: String, movements: [Movement]) {
        self.id = id
        self.name = name
        self.movements = movements
    }
    
    init(id: String, name: String, movementData: Data) {
        self.id = id
        self.name = name
        self.movements = []
        self.movementData = movementData
    }
    
}


extension Tracking {
    typealias `Type` = RealmTracking
    
    func convertToRealmType() -> RealmTracking {
        return RealmTracking(tracking: self)
    }
}

extension Tracking {
    
    var movementData: Data {
        get {
            var data = Data()
            data.appendInt16(movements.count)
            movements.forEach {
                data.appendFloat64($0.coordinate.latitude)
                data.appendFloat64($0.coordinate.longitude)
                data.appendFloat64($0.timestamp)
            }
            return data
        }
        
        set(rawData) {
            do {
                var data = rawData
                
                self.movements = try (0..<data.readInt16("tracking.movements.count")).map { _ in
                    Movement(
                        latitude: try data.readFloat64("tracking.movement.lat"),
                        longitude: try data.readFloat64("tracking.movement.lng"),
                        timestamp: try data.readFloat64("tracking.movement.time")
                    )
                }
            }
            catch {
                Log.message(.error, message: "SET movementData error: \(error)")
                self.movements = []
            }
            
        }
        
    }
}


extension Tracking {
    ///Mảng tọa độ
    var coordinates: [Coordinate] {
        return self.movements.map { $0.coordinate }
    }
    
    ///Mảng `DirectionPoint` gỗm hướng và vị trí của mũi tên chỉ hướng
    var directions: [DirectionPoint] {
        return coordinates
            /**
             *  Từ coordinates tạo ra các cặp coordinate liên tiếp nhau
             */
            .reduce([CoupleCoordinate]()) { (accu: [CoupleCoordinate], coordinate: Coordinate) -> [CoupleCoordinate] in
                if accu.count > 0 { return accu + [CoupleCoordinate(first: accu[accu.count - 1].second, second: coordinate)] }
                return [CoupleCoordinate(first: kInvalidCoordinate, second: coordinate)]
            }
            /**
             *  Lọc để lấy các cặp coordinate valid
             */
            .filter { $0.first.isValid && $0.second.isValid }
            /**
             *  Từ cặp coordinate tạo ra Direction Point: gồm hướng và vị trí
             */
            .map { coordinates -> DirectionPoint in
                DirectionPoint(
                    coordinate: Coordinate(
                        latitude: (coordinates.first.latitude + coordinates.second.latitude) / 2,
                        longitude: (coordinates.first.longitude + coordinates.second.longitude) / 2),
                    direction: GMSGeometryHeading(coordinates.first, coordinates.second)
                )
            } + [DirectionPoint(coordinate: coordinates.last!, direction: GMSGeometryHeading(coordinates[coordinates.count - 1], coordinates.last!))]
    }
    
    ///Các cặp movent liên tiếp
    var coupleMovement: [CoupleMovement] {
//        var accu = [CoupleMovement]()
//        
//        movements.forEach { item in
//            if accu.count > 0 {
//                accu.append(CoupleMovement(first: accu[accu.count - 1].second, second: item))
//            } else {
//                accu.append(CoupleMovement(first: Movement(coordinate: kInvalidCoordinate, timestamp: 0), second: movements[0]))
//            }
//        }
//        return accu.filter { $0.first.coordinate.isValid && $0.second.coordinate.isValid }
        
        return movements
            /**
             *  Từ `movements` tạo ra các cặp Movement liên tiếp nhau
             */
            .reduce([CoupleMovement]()) { (result: [CoupleMovement], movement: Movement) -> [CoupleMovement] in
                
                if result.count > 0 { return result + [CoupleMovement(first: result[result.count - 1].second, second: movement)] }
                
                return [CoupleMovement(first: Movement(coordinate: kInvalidCoordinate, timestamp: 0), second: movement)]
            }
            /**
             *  Lọc để lấy các cặp có coordinate valid
             */
            .filter { $0.first.coordinate.isValid && $0.second.coordinate.isValid }
    }
    
    ///Tổng quãng đường di chuyển
    var totalKm: Double {
        return coupleMovement
            .map { GMSGeometryDistance($0.first.coordinate, $0.second.coordinate) }
            .reduce(0, +) / 1_000
    }
    
    ///Vân tốc giữa hai movement
    func velocity(between first: Movement, and second: Movement) -> Double {
        let distance = GMSGeometryDistance(first.coordinate, second.coordinate) //m
        let time = abs(first.timestamp - second.timestamp) //s
        
        return time == 0 ? 1 : (distance / time) * 3.6 // Đổi sang Km/h
    }
    
    ///Mảng vận tốc giữa hai movement
    var velocitys: [Double] {
        return coupleMovement.map { velocity(between: $0.first, and: $0.second) }
    }
    
    var velocityPoints: [VelocityPoint] {
        var result = [VelocityPoint(index: 0, velocity: 0)]
        
        for (i, item) in velocitys.enumerated() {
            result.append(VelocityPoint(index: i + 1, velocity: CGFloat(item)))
        }
        
        return result
    }
    
    ///Vận tốc max
    var velocityMax: Double {
        
        let filter = velocitys.filter { $0 < 80 }
        
        return  filter.count > 1 ? filter.max() : velocitys.sorted { $0 > $1 }[0]
    }
    
    ///Vận tốc trung bình tinh ra Km/h
    var velocityMedium: Double {
//        let vCount = velocitys.count
//        let vSum = velocitys.reduce(0, +)
//        return vSum / Double(vCount)
        return totalTime == 0 ? 0 : totalKm / totalTime.toHours
    }
    
    ///Mảng thời gian di chuyển giữa hai movement
    var times: [TimeInterval] {
        return [0] + coupleMovement.map { abs($0.second.timestamp - $0.first.timestamp) }
                    
    }
    
    var totalTime: Double {
//        return times.reduce(0, +)
        
        let count = movements.count
        return abs(movements[count - 1].timestamp - movements[0].timestamp)
    }
    
    
}

typealias CoupleMovement = (first: Movement, second: Movement)















