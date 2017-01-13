//
//  LocationSupport.swift
//  BAMapTools
//
//  Created by Thành Lã on 11/11/16.
//  Copyright © 2016 Binh Anh. All rights reserved.
//

import Foundation
import CleanroomLogger
import RxSwift
import RxCocoa
import PHExtensions
import CoreLocation

enum LocationError: Error {
    case invalidCoordinate
}


public class LocationSupport: NSObject {
    
    public enum AuthorizationStatus: Int {
        case enabled, disabled, appDisabled
    }
    
    public enum RequestType {
        case always, whenInUse
    }
    
    public enum RequestStatus {
        case requesting, stopped
    }
    
    
    public static let shared = LocationSupport()
    
    fileprivate let manager = CLLocationManager().config {
        $0.activityType = .automotiveNavigation
        $0.distanceFilter = 20
        $0.pausesLocationUpdatesAutomatically = false
    }
    
    public var currentLocation: CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid
    
    fileprivate var rx_requestSubject = PublishSubject<RequestStatus>()
    
    public var rx_requestStatus: Observable<RequestStatus> {
        return rx_requestSubject.asObservable().shareReplay(1)
    }
    
    public var authorizationStatus: AuthorizationStatus!
    
    public func requestLocationAuthorization(_ type: RequestType) {
        let status = CLLocationManager.authorizationStatus()
        guard status == .notDetermined || status == .denied  else { return }
        switch type {
        case .always: manager.requestAlwaysAuthorization()
        case .whenInUse: manager.requestWhenInUseAuthorization()
        }
    }
    
    fileprivate func startUpdateLocation() {
        manager.startUpdatingLocation()
        rx_requestSubject.onNext(.requesting)
    }
    
    fileprivate func stopUpdateLocation() {
        manager.stopUpdatingLocation()
        rx_requestSubject.onNext(.stopped)
    }
}

extension Reactive where Base: LocationSupport {
    public var authorizationStatus: Observable<Base.AuthorizationStatus> {
        return base.manager.rx.didChangeAuthorizationStatus
            .startWith(CLLocationManager.authorizationStatus())
            .map { status -> Base.AuthorizationStatus in
                guard CLLocationManager.locationServicesEnabled() else { return .disabled }
                if status == .authorizedAlways || status == .authorizedWhenInUse { return .enabled }
                return .appDisabled
            }
            .do( onNext: { [unowned base] in base.authorizationStatus = $0 } )
            .shareReplay(1)
    }
    
    public func startOneTimeLocationUpdate() -> Observable<Coordinate> {
        return Observable<Coordinate>
            .create { [unowned base] obs in
                base.startUpdateLocation()
                
                let disposable = base.manager.rx.didUpdateLocations
                    .subscribe(
                        onNext: {
                            if let location = $0.last {
                                base.currentLocation = location.coordinate
                                obs.onNext(location.coordinate)
                                obs.onCompleted()
                            } else {
                                Log.message(.error, message: "Không lấy được location")
                                obs.onError(LocationError.invalidCoordinate)
                            }
                    }
                )
                
                let error = base.rx_requestStatus
                    .filter { $0 == .stopped }
                    .map { _ in base.currentLocation }
                    .subscribe(
                        onNext: {
                            if $0.isValid {
                                obs.onNext($0)
                                obs.onCompleted()
                            } else {
                                Log.message(.error, message: "Dừng location update trước khi lấy được vị trí")
                                obs.onError(LocationError.invalidCoordinate)
                            }
                    }
                )
                
                return Disposables.create {
                    disposable.dispose()
                    error.dispose()
                    base.stopUpdateLocation()
                    
                }
        }
    }
    
    public func startContinuousLocationUpdate(backgroundUpdate: Bool) -> Observable<CLLocationCoordinate2D> {
        
        return Observable<Coordinate>
            .create { [unowned base] obs in
                if #available(iOS 9, *) {
                    base.manager.allowsBackgroundLocationUpdates = backgroundUpdate
                }
                
                base.startUpdateLocation()
                
                let disposable = base.manager.rx.didUpdateLocations
                    .subscribe(
                        onNext: {
                            
                            if let location = $0.last {
                                base.currentLocation = location.coordinate
                                obs.onNext(location.coordinate)
                            } else {
                                Log.message(.error, message: "Không lấy được location")
                                obs.onError(LocationError.invalidCoordinate)
                            }
                    }
                )
                
                let finished = base.rx_requestStatus
                    .filter { $0 == .stopped }
                    .subscribe(
                        onNext: { _ in
                            obs.onCompleted()
                    }
                )
                
                return Disposables.create {
                    disposable.dispose()
                    finished.dispose()
                    if #available(iOS 9, *) {
                        base.manager.allowsBackgroundLocationUpdates = false
                    }
                    base.stopUpdateLocation()
                }
        }
    }
    
}
