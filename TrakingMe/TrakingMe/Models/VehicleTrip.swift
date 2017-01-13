//
//  VehicleTrip.swift
//  TrakingMe
//
//  Created by Thành Lã on 1/6/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import Foundation
//import GPSNetwork
import GoogleMaps
import PHExtensions
import CoreLocation
import RxSwift

class VehicleTrip {
    
    struct PointInfo {
        let index: Int
        let coordinate: Coordinate
        let time: TimeInterval
        let velocity: Int
        let isStopPoint: Bool
    }
    
    let path: GMSPath
    
    let timeArray: [TimeInterval]
    
    let points: [PointInfo]
    
    let coordinates: [Coordinate]
    
    let totalDistance: Double
    
    let stopPoints: [TrackingStopPoint]
    
    let gsmPoints: [TrackingGSMPoint]
    
    
    init(info: TrackingInfo) {
        /**
         *  Local variable
         */
        let path = GMSPath(fromEncodedPath: info.directionDetail)!
        let coordinates = path.coordinates
//        let count = path.count()
//        let coordinates = (0..<count).map { i in path.coordinate(at: i) }
        
        guard coordinates.count > 0 else {
            totalDistance = 0
            timeArray = []
            self.coordinates = []
            self.path = GMSPath()
            self.stopPoints = []
            self.gsmPoints = []
            self.points = []
            return
        }
        
        /**
         *  Total Distance
         */
        self.totalDistance = Double(info.totalKm)
        
        /**
         *  Path
         */
        self.path = path
        
        /**
         *  Coordinates
         */
        self.coordinates = coordinates
        
        
        /**
         *  Stop Point
         */
        self.stopPoints = info.stopPointList.map { point in
            TrackingStopPoint(startIndex: point.startIndex,
                              startCoordinate: coordinates[point.startIndex],
                              endIndex: point.endIndex,
                              endCoordinate: coordinates[point.endIndex],
                              time: point.startTime,
                              duration: Double(point.duration))
        }
        
        /**
         *  GSM Point
         */
        self.gsmPoints = info.gsmPoint.map { point in
            TrackingGSMPoint(
                startIndex: point.startPoint,
                startCoordinate: coordinates[point.startPoint],
                endIndex: point.endPoint,
                endCoordinate: coordinates[point.endPoint],
                time: point.startTime,
                duration: Double(point.duration))
        }
        
        
        timeArray = info.timePoint.addedTime.map { Double($0) }
        
        var arrayTime: [TimeInterval] = [info.timePoint.startTime + Double(info.timePoint.addedTime[0])]
        
        for i in 1..<info.timePoint.addedTime.count {
            arrayTime.append(arrayTime[i - 1] + Double(info.timePoint.addedTime[i]))
        }
        
        
        
        
        /**
         *  PointInfo
         */
        self.points = (0..<coordinates.count).map { index in
            PointInfo(
                index: index,
                coordinate: coordinates[index],
                time: arrayTime[index],
                velocity: Int(info.velocityPointList[index].velocity),
                isStopPoint: info.stopPointList.filter { $0.startIndex == index }.count > 0
            )
        }
    }
}


private typealias CoordinateCouple = (first: Coordinate, second: Coordinate)
