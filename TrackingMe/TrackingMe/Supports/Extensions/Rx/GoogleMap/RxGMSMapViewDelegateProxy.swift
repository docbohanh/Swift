//
//  RxGMSMapViewDelegateProxy.swift
//  Staxi
//
//  Created by Hoan Pham on 3/17/16.
//  Copyright © 2016 Hoan Pham. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa


class RxGMSMapViewDelegateProxy : DelegateProxy, DelegateProxyType, GMSMapViewDelegate {
    
    class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        guard let mapView = object as? GMSMapView else {
            crashApp(message: "rx gmsmapview delegate error while casting object")
        }
        
        return mapView.delegate
    }
    
    class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        guard let mapView = object as? GMSMapView else {
            crashApp(message: "rx gmsmapview delegate error while casting object 2")
        }
        
        guard let delegate = delegate as? GMSMapViewDelegate else {
            crashApp(message: "rx gmsmapview delegate error while set delegate")
        }
        
        mapView.delegate = delegate
    }
}
