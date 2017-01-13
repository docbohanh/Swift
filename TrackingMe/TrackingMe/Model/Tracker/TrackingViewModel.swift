//
//  TrackingViewModel.swift
//  TrakingMe
//
//  Created by Thành Lã on 1/6/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import Foundation
import CleanroomLogger
import PHExtensions
import OptionalExtensions
import RxSwift

class TrackingViewModel {
    fileprivate let bag = DisposeBag()
    let appForeground = Variable<Bool>(true)
    
    let userInfo: UserInfo
    let vehicleInfo: RealTimeVehicle
    var selectedSegment: Variable<TrackingSegment>
    
    var tripInfoResponse = Variable<TrackingInfo?>(nil)
    
    var tripInfo = Variable<VehicleTrip?>(nil)
    
    var rx_forcedRequest = PublishSubject<TrackingSegment>()
    
    init(userInfo: UserInfo, vehicleInfo: RealTimeVehicle) {
        vehicleInfo.fakeColor = .normalSpeed
        self.vehicleInfo = vehicleInfo
        self.userInfo = userInfo
        
        self.selectedSegment = Variable<TrackingSegment>(TrackingSegment(index: -1,title: "", value: .fixedValue(0.hour)))
        
        Observable.of(
            NotificationCenter.default.rx.notification(NSNotification.Name.UIApplicationWillEnterForeground).replaceWith(true),
            NotificationCenter.default.rx.notification(NSNotification.Name.UIApplicationDidEnterBackground).replaceWith(false)
            )
            .merge()
            .bindTo(appForeground)
            .addDisposableTo(bag)
        
        tripInfoResponse
            .asObservable()
            .filter { $0.isNone }
            .subscribe(onNext: { [unowned self] _ in
                self.tripInfo.value = nil
            })
            .addDisposableTo(bag)
        
        tripInfoResponse
            .asObservable()
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: DispatchQoS.background))
            .filterNil()
            .map { VehicleTrip(info: $0) }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.tripInfo.value = $0
            })
            .addDisposableTo(bag)
        
        rx_forcedRequest
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                self.selectedSegment.value = TrackingSegment(index: -1,title: "", value: .fixedValue(0.hour))
                self.selectedSegment.value = $0
            })
            .addDisposableTo(bag)
        
        //TODO: notification view
        
    }
    
}
