//
//  Collection+Ex.swift
//  OneTaxi
//
//  Created by Hoan Pham on 8/8/16.
//  Copyright © 2016 Hoan Pham. All rights reserved.
//

import Foundation

public extension Collection {
    public func isIntersect<T>(with another: [T], condition: (Iterator.Element, T) -> Bool) -> Bool {
        firstLoop: for element in self {
            secondLoop: for objOfT in another {
                if condition(element, objOfT) { return true }
            }
        }
        return false
    }
}

public extension Collection where Iterator.Element: Equatable {
    public func isIntersect(with another: [Iterator.Element]) -> Bool {
        firstLoop: for element in self {
            secondLoop: for anotherObj in another {
                if element == anotherObj { return true }
            }
        }
        return false
    }
}
