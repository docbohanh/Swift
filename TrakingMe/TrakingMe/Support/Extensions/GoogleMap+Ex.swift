//
//  GoogleMap+Ex.swift
//  OneTaxi
//
//  Created by Hoan Pham on 8/8/16.
//  Copyright © 2016 Hoan Pham. All rights reserved.
//

import Foundation

func == (l: GMSMarker, r: GMSMarker) -> Bool {
    return l.position == r.position
}
