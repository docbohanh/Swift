//
//  TrackingPolyline.swift
//  BAMapTools
//
//  Created by Thành Lã on 12/27/16.
//  Copyright © 2016 Binh Anh. All rights reserved.
//

import UIKit
import GoogleMaps
import PHExtensions

typealias CoupleCoordinate = (first: Coordinate, second: Coordinate)

public class TrackingPolyline {
    var name: String
    var line: GMSPolyline
    
    var arrows: [GMSMarker]

    var map: GMSMapView? {
        didSet {
            line.map = map
            arrows.forEach { $0.map = map }
        }
    }
    
    public init(tracking: Tracking) {
        self.name = tracking.name
        
        let coordinates = tracking.movements.map { $0.coordinate }
        
        self.line = GMSPolyline(path: Utility.shared.getGMSPath(from: coordinates))
        self.line.strokeWidth = 3
        
        self.line.strokeColor = UIColor.tracking
        
        let start = GMSMarker()
        start.isFlat = true
        start.isTappable = false
        start.position = coordinates[0]
        start.icon = Icon.Tracking.start
        
        let end = GMSMarker()
        end.isFlat = true
        end.isTappable = false
        end.position = coordinates[coordinates.count - 1]
        end.icon = Icon.Tracking.end
                
        self.arrows = [start, end] + coordinates
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
        
            /**
             * Từ `DirectionPoint` tạo ra mảng các `marker` là mũi tên chỉ hướng của `TrackingLine`
             */
            .map { arrow -> GMSMarker in
                let marker = GMSMarker()
                marker.isFlat = true
                marker.isTappable = false
                marker.position = arrow.coordinate
                marker.rotation = arrow.direction
                marker.icon = Icon.Tracking.arrow.tint(.orange)
                
                return marker
            }
        
        
    }
}

































