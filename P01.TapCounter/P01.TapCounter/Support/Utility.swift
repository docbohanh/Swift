//
//  Utility.swift
//  P01.TapCounter
//
//  Created by MILIKET on 12/29/16.
//  Copyright © 2016 Bình Anh Electonics. All rights reserved.
//

import Foundation

// MARK: Global

postfix operator ..

postfix func ..<T: RawRepresentable> (lhs: T) -> T.RawValue {
    return lhs.rawValue
}

func == (lhs: IndexPath, rhs: IndexPath) -> Bool {
    return lhs.compare(rhs) == .orderedSame
}
