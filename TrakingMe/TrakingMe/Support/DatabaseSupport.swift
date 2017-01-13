//
//  DatabaseSupport.swift
//  TrakingMe
//
//  Created by Thành Lã on 12/30/16.
//  Copyright © 2016 Bình Anh Electonics. All rights reserved.
//

import Foundation
import RealmSwift
import CleanroomLogger
import RxExtensions
import RxSwift
import PHExtensions

public class DatabaseSupport {
    public static let shared = DatabaseSupport()
    
    func deleteAllData() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        }
        catch {
            Log.message(.error, message: "deleteAllData ERROR: \(error)")
        }
    }
}

extension DatabaseSupport {
    func insert(tracking: RealmTracking) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(tracking, update: true)
            }
        }
        catch {
            Log.message(.error, message: "Realm - Cannot insert Tracking: \(error)")
        }
    }
    
    func deleteAllTracking() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(realm.objects(RealmTracking.self))
            }
        }
        catch {
            Log.message(.error, message: "Realm - Cannot deleteAllTracking: \(error)")
        }
    }
    
    func getTracking() -> [RealmTracking] {
        do {
            return try Realm().objects(RealmTracking.self).toArray().sorted { $0.time < $1.time }
        }
        catch {
            Log.message(.error, message: "Realm - Cannot getTracking: \(error)")
            return []
        }
    }
    
    func getTracking(id: String) -> RealmTracking? {
        do {
            return try Realm().objects(RealmTracking.self).toArray().first { $0.id == id }
        }
        catch {
            Log.message(.error, message: "Realm - Cannot getTracking: \(error)")
            return nil
        }
    }
    
    func deleteTracking(id: String) {
        do {
            let realm = try Realm()
            try realm.write {
                if let object = realm.object(ofType: RealmTracking.self, forPrimaryKey: id) {
                    realm.delete(object)
                }
                
            }
        }
        catch {
            Log.message(.error, message: "Realm - Cannot delete Tracking: \(error)")
        }
    }
    
    func updateName(of tracking: RealmTracking, with newName: String) {
        do {
            let realm = try Realm()
            try realm.write {
                tracking.name = newName
            }
        }
        catch {
            Log.message(.error, message: "Realm - Cannot update name Tracking: \(error)")
        }
    }
}











