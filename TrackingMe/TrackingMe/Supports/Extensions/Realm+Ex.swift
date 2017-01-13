//
//  Realm+Ex.swift
//  OneTaxi
//
//  Created by Hoan Pham on 8/8/16.
//  Copyright © 2016 Hoan Pham. All rights reserved.
//

import Foundation
import RealmSwift

//public extension Results {
//    public func toArray() -> [Results.Iterator.Element] {
//        return Array(self)
//    }
//}

//public class RealmData: Object {
//    private dynamic var data = NSData()
//    
//    public var value: Data {
//        return data as Data
//    }
//    
//    public convenience init(_ data: Data = Data()) {
//        self.init()
//        self.data = data as NSData
//    }
//}

public class RealmString: Object {
    private dynamic var string: String = ""
    
    public var value: String {
        return string
    }
    
    public convenience init(_ string: String) {
        self.init()
        self.string = string
    }
}


public class RealmInt: Object {
    private dynamic var int: Int = 0
    
    public var value: Int {
        return int
    }
    
    public convenience init(_ int: Int) {
        self.init()
        self.int = int
    }
}

public class RealmImage: Object {
    private dynamic var length: Int = 0
    private dynamic var data = NSData()
    
    public var value: Data {
        return data as Data
    }
    
    public convenience init(_ data: Data) {
        self.init()
        self.data = data as NSData
        self.length = data.count
    }
}

