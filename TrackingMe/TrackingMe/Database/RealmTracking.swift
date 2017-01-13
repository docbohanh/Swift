//
//  RealmTracking.swift
//  TrakingMe
//
//  Created by Thành Lã on 12/30/16.
//  Copyright © 2016 Bình Anh Electonics. All rights reserved.
//

import Foundation
import RealmSwift
import CleanroomLogger
import PHExtensions
import GoogleMaps

class RealmTracking: Object {
    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var movements: NSData = NSData()
    dynamic var time: TimeInterval = 0
    
    public convenience init(tracking: Tracking) {
        self.init()
        self.id = tracking.id
        self.name = tracking.name
        self.movements = tracking.movementData as NSData
        self.time = tracking.movements.count > 0 ? tracking.movements[tracking.movements.count - 1].timestamp : 0
    }
    
    public override static func primaryKey() -> String? {
        return "id"
    }
}

extension RealmTracking {
    public func convertToSyncType() -> Tracking {
        return Tracking(id: self.id,
                        name: self.name,
                        movementData: self.movements as Data)
    }
}

