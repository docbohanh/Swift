//
//  VehicleTrip.swift
//  TrakingMe
//
//  Created by Thành Lã on 1/6/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import Foundation
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
        let velocityColor: LineSegment.Category
        let isStopPoint: Bool
    }
    
    let path: GMSPath
    
    let points: [PointInfo]
    
    let coordinates: [Coordinate]
    
    let totalDistance: Double
    
    let lineSegment: [LineSegment]
    
    let stopPoints: [TrackingStopPoint]
    
    let gsmPoints: [TrackingGSMPoint]
    
    let directionPoints: [DirectionPoint]
    
    
    init(info: TrackingInfo) {
        /**
         *  Local variable
         */
        let path = GMSPath(fromEncodedPath: info.rawPath)!
        let count = path.count()
        let coordinates = (0..<count).map { i in path.coordinate(at: i) }
        
        let velocityColorParser = { (x: Int) -> LineSegment.Category in
            switch x {
            case 0..<CompanyConfiguration.instance.DefaultMaxVelocityGray:
                return .stop
                
            case 0..<CompanyConfiguration.instance.DefaultMaxVelocityBlue:
                return .normal
                
            case 0..<CompanyConfiguration.instance.DefaultMaxVelocityOrange:
                return .highSpeed
                
            case 0..<CompanyConfiguration.instance.DefaultMaxVelocityRed:
                return .speeding
                
            default:
                return .unknown
            }
        }
        
        let velocityColors = info.velocityPoints.map { velocityColorParser($0) }
        
        /**
         *  Total Distance
         */
        self.totalDistance = info.totalDistance
        
        /**
         *  Path
         */
        self.path = path
        
        /**
         *  Coordinates
         */
        self.coordinates = coordinates
        
        /**
         *  Line Segment
         */
        self.lineSegment = (0..<velocityColors.count)
            /**
             *  Convert velocity color sang thành dạng (Index, Color)
             *  Index từ 0 -> index của last item trong velocityColors
             */
            .map { [velocityColors] i in ColorIndex(index: i, color: velocityColors[i]) }
            /**
             *  Nếu 2 color index đứng cạnh nhau mà có màu trùng nhau thì sẽ loại ColorIndex đứng trước
             *  Và thêm Color Index mới vào
             */
            .reduce([ColorIndex]()) { (accu: [ColorIndex], colorIndex: ColorIndex) -> [ColorIndex] in
                return accu.count == 0 ? [colorIndex] :
                    accu[accu.count - 1].color == colorIndex.color ? accu[0..<accu.count - 1] + [colorIndex] :
                    accu + [colorIndex]
                
            }
            /**
             *  Từ ColorIndex, tạo ra các LineSegment có các start và endIndex liền mạch
             *  Từ 0 -> cuối lộ trình
             */
            .reduce([LineSegment]()) { (accu: [LineSegment], colorIndex: ColorIndex) -> [LineSegment] in
                return accu.count > 0 ?
                    accu + [LineSegment(startIndex: accu[accu.count - 1].endIndex, endIndex: colorIndex.index, category: colorIndex.color)] :
                    [LineSegment(startIndex: 0, endIndex: colorIndex.index, category: colorIndex.color)]
        }
        
        /**
         *  Stop Point
         */
        self.stopPoints = info.stopPoints.map { [coordinates] in
            TrackingStopPoint(
                startIndex: $0.startIndex,
                startCoordinate: coordinates[$0.startIndex],
                endIndex: $0.endIndex,
                endCoordinate: coordinates[$0.endIndex],
                category: $0.category,
                time: $0.time,
                duration: $0.duration)
        }
        
        /**
         *  GSM Point
         */
        self.gsmPoints = info.gsmPoints.map { [coordinates] in
            TrackingGSMPoint(
                startIndex: $0.startIndex,
                startCoordinate: coordinates[$0.startIndex],
                endIndex: $0.endIndex,
                endCoordinate: coordinates[$0.endIndex],
                time: $0.time,
                duration: $0.duration)
        }
        
        /**
         *  PointInfo
         */
        self.points = (0..<coordinates.count).map { [coordinates, info] index in
            PointInfo(
                index: index,
                coordinate: coordinates[index],
                time: info.timePoints[index],
                velocity: info.velocityPoints[index],
                velocityColor: velocityColors[index],
                isStopPoint: info.stopPoints.filter { $0.startIndex == index }.count > 0
            )
        }
        
        
        /**
         *  Direction Point
         */
        self.directionPoints = coordinates
            /**
             *  Từ coordinates tạo ra các cặp coordinate liên tiếp nhau
             */
            .reduce([CoordinateCouple]()) { (accu: [CoordinateCouple], coordinate: Coordinate) -> [CoordinateCouple] in
                if accu.count > 0 { return accu + [CoordinateCouple(first: accu[accu.count - 1].second, second: coordinate)] }
                return [CoordinateCouple(first: kInvalidCoordinate, second: coordinate)]
            }
            /**
             *  Lọc để lấy các cặp coordinate valid
             */
            .filter {
                $0.first.isValid && $0.second.isValid
            }
            /**
             *  Từ cặp coordinate tạo ra Direction Point: gồm hướng và vị trí
             */
            .map {
                DirectionPoint(
                    coordinate: Coordinate(latitude: ($0.first.latitude + $0.second.latitude) / 2, longitude: ($0.first.longitude + $0.second.longitude) / 2),
                    direction: GMSGeometryHeading($0.first, $0.second))
            }
            /**
             *  Lọc bớt dữ liệu. Chỉ lấy những điểm thỏa mãn một trong các yêu cầu:
             *  - Có góc quay lệch > 30 độ
             *  - Cách điểm cũ 1.000m
             */
            .reduce([DirectionPoint]()) { (accu: [DirectionPoint], point: DirectionPoint) -> [DirectionPoint] in
                if accu.count == 0 { return [point] }
                else if (accu[accu.count - 1] == point && GMSGeometryDistance(accu[accu.count - 1].coordinate, point.coordinate) < 1_000) {
                    return accu
                }
                return accu + [point]
                
        
        }
        
    }
}

private typealias ColorIndex = (index: Int, color: LineSegment.Category)
private typealias CoordinateCouple = (first: Coordinate, second: Coordinate)
