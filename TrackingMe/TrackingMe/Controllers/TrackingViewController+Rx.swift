//
//  TrackingViewController+Rx.swift
//  TrakingMe
//
//  Created by Thành Lã on 1/6/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleMaps
import PHExtensions

typealias BooleanCouple = (first: Bool, second: Bool)

//MARK: Rx Tracking
extension TrackingViewController {
    internal func rx_userMovementTracking() {
        LocationSupport.shared.rx.authorizationStatus
            .asObservable()
            .filter { $0 == .enabled }
            .flatMapLatest { _ in
                LocationSupport.shared.rx.startContinuousLocationUpdate(backgroundUpdate: true)
                    .debugWithLogger(.debug, message: "Continuous Location Update")
            }
            .map {
                Movement(
                    latitude: $0.latitude,
                    longitude: $0.longitude,
                    timestamp: Date().timeIntervalSince1970
                )
            }
            .debugWithLogger(.debug, message: "Update user movement")
            .subscribe(
                onNext: { [unowned self] in
                    self.tracking.movements.append($0)
                }
            )
            .addDisposableTo(bag)
    }
    
    internal func rx_updateTrackingToRealm() {
        Observable
            .of(
                saveTrackingSignal.asObservable(),
                NotificationCenter.default.rx.notification(Notification.Name(AppNotification.SaveTrackingSignal.rawValue)).map { _ in }
            )
            .merge()
            .debugWithLogger(.debug, message: "Update Tracking To Realm")
            .map { [unowned self] in self.tracking }
            .filter { $0.movements.count > 1 }
            .map { $0.convertToRealmType() }
            .subscribe(
                onNext: { DatabaseSupport.shared.insert(tracking: $0) }
            )
            .addDisposableTo(bag)
        
    }
}

/*
//------------------------------------
// MARK: - RX
//------------------------------------

extension TrackingViewController {
    
    
    func rx_stopLocationWhenBackground() {
        /*
         viewModel.appForeground
         .asObservable()
         .skip(1)
         .subscribeNext { [unowned self] in
         self.mapView.myLocationEnabled = $0
         }
         .addDisposableTo(bag)
         */
    }
    
    /**
     Hàm xóa toàn bộ markers và polyline trên bản đồ
     */
    func rx_clearMarkers() {
        viewModel.tripInfo.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] _ in
                self.mapView.clear()
                self.carMarker = VehicleMarker(info: self.viewModel.vehicleInfo)
                self.carMarker.zIndex = 15
                self.carMarker.position = kInvalidCoordinate
                self.carMarker.tracksViewChanges = true
                self.polyline = nil
                self.staticMarkers = []
                self.inspectableMarkers = []
            })
            .addDisposableTo(bag)
    }
    
    /**
     Khi nhận được trip info mới hoặc người dùng bỏ chọn marker (tap ra ngoài bản đồ)
     Thì đẩy lại thông tin over view vào footer
     */
    func rx_overviewInfo() {
        viewModel.tripInfo.asObservable()
            .filterNil()
            .map { $0.totalDistance }
            .withLatestFrom(viewModel.selectedSegment.asObservable().map { $0.value }) { ($0, $1) }
            .map { distance, time -> (Double, TimeInterval) in
                switch time {
                case .fixedValue(let value):
                    return (value, distance)
                    
                case .rangeValue(let from, let to):
                    return (to - from, distance)
                }
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] time, distance in
                self.floatView.totalDistance = distance
                
                self.navigationItem.rightBarButtonItem = self.info
            })
            .addDisposableTo(bag)
    }
    
    /**
     Người dùng bấm vào một tappable marker
     */
    func rx_tapOnMarkers() {
        /**
         *  Bấm vào stop marker
         *
         *  @return
         */
        mapView.rx_selectedMarker
            .asObservable()
            .filter {
                if let _ = $0 as? StopMarker { return true }
                return false
            }
            .mapToType(StopMarker.self, ignoreError: true)
            .map { $0.info }
            .subscribe(onNext: { [unowned self] in
                self.infoWindow.state = .detailsStopPoint($0)
            })
            .addDisposableTo(bag)
        
        /**
         *  Bấm vào GSM marker
         *
         *  @return
         */
        mapView.rx_selectedMarker
            .asObservable()
            .filter {
                if let _ = $0 as? GSMLostMarker { return true }
                return false
            }
            .mapToType(GSMLostMarker.self, ignoreError: true)
            .map { ($0.status, $0.info) }
            .subscribe(onNext: { [unowned self] status, info in
                switch status {
                case .lost:
                    self.infoWindow.state = .detailsLostGSMPoint(info)
                case .received:
                    self.infoWindow.state = .detailsReceivedGSMPoint(info)
                }

            })
            .addDisposableTo(bag)
    }
    
    
    func rx_drawStartAndEndPoints() {
//        viewModel.tripInfo
//            .asObservable()
//            .filterNil()
//            .flatMap { $0.coordinates.toObservable().take(1) }
//            .map { PointMarker(status: .Start, position: $0) }
//            .observeOn(MainScheduler.instance)
//            .subscribeNext { [unowned self] in
//                $0.map = self.mapView
//                self.staticMarkers.append($0)
//            }
//            .addDisposableTo(bag)
//        
//        viewModel.tripInfo
//            .asObservable()
//            .filterNil()
//            .flatMap { $0.coordinates.toObservable().takeLast(1) }
//            .map { PointMarker(status: .End, position: $0) }
//            .observeOn(MainScheduler.instance)
//            .subscribeNext { [unowned self] in
//                $0.map = self.mapView
//                self.staticMarkers.append($0)
//            }
//            .addDisposableTo(bag)
    }
    /**
     Vẽ điểm mất gsm trên bản đồ
     */
    func rx_drawGSMPoints() {
//        viewModel.tripInfo
//            .asObservable()
//            .filterNil()
//            .map { $0.gsmPoints }
//            .flatMap { $0.toObservable() }
//            .observeOn(MainScheduler.instance)
//            .flatMap { x -> Observable<GSMLostMarker> in
//                return Observable.create { observer in
//                    observer.onNext(GSMLostMarker(status: .Lost, position: x.startCoordinate, info: x))
//                    observer.onNext(GSMLostMarker(status: .Received, position: x.endCoordinate, info: x))
//                    observer.onCompleted()
//                    return NopDisposable.instance
//                }
//            }
//            .subscribeNext { [unowned self] in
//                $0.map = self.mapView
//                self.inspectableMarkers.append($0)
//            }
//            .addDisposableTo(bag)
        
    }
    
    /**
     Vẽ điểm dừng và điểm mất GPS trên bản đồ
     */
    func rx_drawStopPoints() {
        
        /**
         *  Phân tích dữ liệu
         */
//        let stopPoints = self.viewModel.tripInfo
//            .asObservable()
//            .filterNil()
//            .map { $0.stopPoints }
//            .flatMap { $0.toObservable() }
//            .shareReplay(1)
        
        /**
         *  Vẽ điểm dừng
         */
//        stopPoints
//            .filter { $0.category == .drawPoint }
//            .observeOn(MainScheduler.instance)
//            .map { StopMarker(position: $0.startCoordinate, info: $0) }
//            .subscribeNext { [unowned self] in
//                $0.map = self.mapView
//                self.inspectableMarkers.append($0)
//            }
//            .addDisposableTo(bag)
        
        /**
         *  Vẽ điểm mất GPS
         *  28 - 5 - 2016
         *  Bỏ vẽ đoạn dừng đỗ mà chỉ vẽ như bình thường
         */
        /*
         stopPoints
         .filter { $0.category == .DrawPath }
         .observeOn(MainScheduler.instance)
         .flatMap { x -> Observable<GPSLostMarker> in
         return Observable.create { observer in
         observer.onNext(GPSLostMarker(status: .Lost, position: x.startCoordinate))
         observer.onNext(GPSLostMarker(status: .Received, position: x.endCoordinate))
         observer.onCompleted()
         return NopDisposable.instance
         }
         }
         .subscribeNext { [unowned self] in
         $0.map = self.mapView
         self.staticMarkers.append($0)
         }
         .addDisposableTo(bag)
         */
        
        
    }
    
    /**
     Vẽ mũi tên chỉ hướng của lộ trình
     */
    func rx_drawDirectionArrow() {
//        self.viewModel.tripInfo
//            .asObservable()
//            .filterNil()
//            .map { $0.directionPoints }
////            .flatMap { $0.toObservable() }
//            .observeOn(MainScheduler.instance)
//            .map { ArrowMarker(position: $0.c, direction: <#T##CLLocationDirection#>) }
//            .subscribeNext { [unowned self] in
//                $0.map = self.mapView
//                self.staticMarkers.append($0)
//            }
//            .addDisposableTo(bag)
    }
    
    /**
     Vẽ đường đi của xe trên bản đồ
     */
    func rx_drawPolyline() {
        let polyline = viewModel.tripInfo
            .asObservable()
            .filterNil()
            .observeOn(MainScheduler.instance)
            .map { GMSPolyline(path: $0.path) }
        
        let styleSpan = viewModel.tripInfo
            .asObservable()
            .filterNil()
            .map { $0.lineSegment }
            .observeOn(MainScheduler.instance)
            .map { segments in
                segments.map { GMSStyleSpan(color: $0.category.toColor(), segments: Double($0.endIndex - $0.startIndex)) }
        }
        
        Observable.combineLatest(polyline, styleSpan) { ($0, $1) }
            .subscribe(onNext: { [unowned self] line, style in
                line.spans = style
                line.strokeWidth = 3
                line.map = self.mapView
                self.polyline = line
            })
            .addDisposableTo(bag)
    }
    
    
//    func rx_setupSliderChangesWithInfoObservable() -> Observable<VehicleTrip.PointInfo> {
//        return controlFooterView.rx_sliderValueChangedManually
//            .asObservable()
//            .observeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background)
//            .withLatestFrom(viewModel.tripInfo.asObservable().filterNil()) { ($0, $1) }
//            .map { sliderValue, tripInfo in tripInfo.points[sliderValue] }
//            .observeOn(MainScheduler.instance)
//            .shareReplay(1)
//    }
    
    func rx_sliderControllerObservable(_ sliderChanges: Observable<VehicleTrip.PointInfo>) {
        /**
         *  Người dùng thay đổi slider -> gán giá trị này vào sliderValue
         */
        controlFooterView.rx_sliderValueChangedManually
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                self.controlFooterView.rx_sliderValue.value = $0
                if $0 == self.controlFooterView.rx_sliderCount.value {
                    self.controlFooterView.rx_playState.value = .pause
                }
            })
            .addDisposableTo(bag)
        
        let positionChanges = sliderChanges
            .map { $0.coordinate }
            .shareReplay(1)
        /**
         *  Nếu đang tracking thì cho map chạy theo xe luôn
         */
        positionChanges.asObservable()
            .filter { [unowned self] _ in self.trackingWhileDraggingSlider.value }
            .subscribe(onNext: { [unowned self] in
                self.animateOnMap(0.05.second, self.mapView.animate(toLocation: $0))
            })
            .addDisposableTo(bag)
        
        /**
         *  *  Animation marker đến vị trí mới
         */
//        positionChanges
//            .subscribe(onNext: { [unowned self] in
//                self.carMarker.animateMarkerForTracking(
//                    $0,
//                    moveDuration: (0.05.second) ,
//                    rotateDuration: (0.05.second / 2))
//            }
//            .addDisposableTo(bag)
    }
    
    func rx_setupPeriodicalInfoEventsObservable() -> Observable<(VehicleTrip.PointInfo, TrackingControlFooterView.PlaySpeed)> {
        /**
         *  Kết hợp các signal của:
         *  - Thay đổi trạng thái play / pause
         *  - Thay đổi tốc độ chạy lộ trình
         *  - Người dùng thay đổi giá trị slider value
         */
        return Observable.combineLatest(
            controlFooterView.rx_playState.asObservable(),
            controlFooterView.rx_playSpeed.asObservable(),
            controlFooterView.rx_sliderValueChangedManually.asObservable()
                .startWith(0)
                .throttle(0.15.second, scheduler: MainScheduler.instance)
        ) { state, speed, _ in (state, speed) }
            
            /**
             *  Trạng thái phải là đang play
             */
            .filter { x, _ in x == .play }
            /**
             *  Lấy ra dữ liệu phần dữ liệu lộ trình (coordinates)
             *  Từ vị trí của slider cho đến hết lộ trình
             */
            .observeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .flatMapLatest { [unowned self] _, _ -> Observable<[VehicleTrip.PointInfo]> in
                self.rx_getRemainPointsBasedOnSliderValue()
            }
            /**
             *  Lấy ra vận tốc chạy hiện tại
             */
            .withLatestFrom(controlFooterView.rx_playSpeed.asObservable()) { ($0, $1) }
            /**
             *  Kết hợp vận tốc chạy và dữ liệu lộ trình
             *  Tạo ra chuỗi signal send ra dữ liệu lộ trình sau một khoảng thời gian nhất định
             *  (Vận tốc chạy nhanh -> send nhanh và ngược lại)
             *  ------------------
             *  Chuỗi signal này sẽ bị kết thúc khi:
             *  - Trạng thái chạy bị chuyển sang .Pause
             *  - Tốc độ chạy bị thay đổi
             *  - Có dữ liệu lộ trình mới
             *  - Người dùng thay đổi vị trí slider
             */
            .flatMapLatest { [unowned self] point, speed in
                self.rx_sendSignalEventsPeriodically(point, speed)
                    .takeUntil(self.rx_cancelCarAnimationObservable())
            }
            /**
             *  Nếu car marker chưa có trên map
             *  Set vị trí marker trên map
             *  -------------------------------
             *  Di chuyển slider lên 1 đơn vị
             *  - Nếu chưa có carMarker trên map -> tương đương với việc slider ở vị trí 0
             *      -> Không tăng giá trị slider. Tránh việc marker ở vị trí đầu tiên (0) mà slider đã ở vị trí (1) rồi
             *  - Nếu coordinate.isValid thì mới tăng -> Do app chủ động add thêm một giá trị kInvalidLocation
             *  Để biết đâu là điểm kết thúc của lộ trình.
             */
            .observeOn(MainScheduler.instance)
            .do(onNext: { [unowned self] in
                if let _ = self.carMarker.map {
                    if $0.coordinate.isValid { self.controlFooterView.rx_sliderValue.value += 1 }
                } else {
                    self.carMarker.position = $0.coordinate
                    self.carMarker.map = self.mapView
                }
            })
            /**
             *  Lấy ra vận tốc hiện tại
             */
            .withLatestFrom(controlFooterView.rx_playSpeed.asObservable()) { ($0, $1) }
            .shareReplay(1)
    }
    
    func rx_periodicalEventsControllerObservable(_ signal: Observable<(VehicleTrip.PointInfo, TrackingControlFooterView.PlaySpeed)>) {
        /**
         *  Nếu vị trí là valid -> di chuyển carMarker
         *  Nếu ko -> đây là điểm kết thúc -> chuyển sang trạng thái .Pause
         */
        signal
            .subscribe(onNext: { [unowned self] point, speed in
                if point.coordinate.isValid {
                    self.carMarker.animateMarkerForTracking(
                        point.coordinate,
                        moveDuration: (AppConfig.Tracking.BaseTimeMoving / speed.multiplier).second,
                        rotateDuration: (AppConfig.Tracking.BaseTimeRotating / speed.multiplier).second)
                }
                else {
                    self.controlFooterView.rx_playState.value = .pause
                }
            })
            .addDisposableTo(bag)
    }
    
    func rx_setupInfoChangesObservable(
        _ firstSignal: Observable<VehicleTrip.PointInfo>,
        _ secondSignal: Observable<(VehicleTrip.PointInfo, TrackingControlFooterView.PlaySpeed)>) -> Observable<VehicleTrip.PointInfo> {
        
        return Observable
            .of(
                firstSignal,
                secondSignal.map { point, _ in point }
            )
            .merge()
            .filter { $0.coordinate.isValid }
            .shareReplay(1)
    }
    
    
    func rx_infoChangeControllerObservable(_ signal: Observable<VehicleTrip.PointInfo>) {
        
        /**
         *  Thay đổi màu sắc của text vận tốc
         */
        signal
            .map { $0.velocityColor }
            .startWith(.normal)
            .distinctUntilChanged()
            .map { $0.toColor() }
            .subscribe(onNext: { [unowned self] color in
                self.floatView.velocityColor = color
            })
            .addDisposableTo(bag)
        
        /**
         *  Thay đổi thông tin của text vận tốc - thời gian
         */
        signal
            .subscribe(onNext: { [unowned self] info in
                self.floatView.info = info
            })
            .addDisposableTo(bag)
    }
    
    func rx_trackingControllerObservable(_ periodicalSignal: Observable<(VehicleTrip.PointInfo, TrackingControlFooterView.PlaySpeed)>) {
//        /**
//         *  Tap lên nút tracking -> bật chế độ di chuyển map theo xe khi kéo slider
//         */
//        myLocation.rx.tap
//            .subscribe(onNext: { [unowned self] _ in
//                self.trackingWhileDraggingSlider.value = true
//            })
//            .addDisposableTo(bag)
//        
//        /**
//         *  Khi người dùng tap vào nút tracking hoặc tự động tracking được kích hoạt (nhận lộ trình mới)
//         */
//        Observable
//            .of(
//                myLocation.rx.tap.asObservable(),
//                trackingAutomatically.asObservable(),
//                mapView.rx_selectedMarker.filterNil().filter { $0 is VehicleMarker }.replaceWith()
//            )
//            .merge()
//            /**
//             *  Ẩn info windows nếu có
//             *  Di chuyển map về mức zoom 14 (để có thể nhìn được đường tốt hơn)
//             */
//            .doOnNext { [unowned self] in
//                self.mapView.selectedMarker = nil
//                self.animateOnMap(0.5.second, self.mapView.animateToZoom(14))
//            }
//            /**
//             *  Tạo ra một observable lắng nghe sự kiện pan trên bản đồ
//             *  Observable này sẽ bị dispose khi người dùng pan trên map
//             */
//            .map { [unowned self] in
//                self.rx_createPanGestureOnMap()
//            }
//            /**
//             *  Kết hợp với dữ liệu coordinate được gửi đều đặn (bên trên)
//             *  Tạo ra một observable mới, gửi thông tin coordinate
//             *  Observable này kết thúc khi có sự kiện pan on map hoặc người dùng chọn một marker nào đó để xem info windows
//             *  Kết thúc -> dừng tracking slider
//             */
//            .flatMapLatest { [unowned self] panAndTapOnMap in
//                periodicalSignal
//                    .takeUntil(panAndTapOnMap)
//                    .takeUntil(self.mapView.rx_selectedMarker.filterNil())
//                    .doOnCompleted { [unowned self] _ in
//                        self.trackingWhileDraggingSlider.value = false
//                }
//            }
//            /**
//             *  Nhận dữ liệu -> animate map theo vị trí
//             */
//            .map { point, speed in (point.coordinate, speed) }
//            .subscribeNext { [unowned self] coordinate, speed in
//                guard coordinate.isValid else { return }
//                self.animateOnMap((1 / speed.multiplier).second, self.mapView.animateToLocation(coordinate))
//            }
//            .addDisposableTo(bag)
    }
    
    /**
     Set giá trị vào slider và thao tác trên slider
     */
    func rx_setupVehicleTripInfoObservable() {
        
        
        /**
         *  Nhận được trip mới và không có dữ liệu
         *  Set giá trị slider = 0
         */
        viewModel.tripInfo
            .asObservable()
            .filter { $0.isNone }
            .subscribe(onNext: { [unowned self] _ in
                self.controlFooterView.rx_sliderCount.value = 0
            })
            .addDisposableTo(bag)

        
//        viewModel.tripInfo
//            .asObservable()
//            .map { $0.isSome ? true : false }
//            .throttle(1.0.second, scheduler: MainScheduler.instance)
//            .subscribe(onNext: { [unowned self] in
//                self.controlFooterViewHeightConstraint.update(inset: $0 ? self.controlFooterView.viewHeight() : 0)
//                
//                UIView.animate(withDuration: 0.4.second, animations: {
//                    self.mapView.padding.bottom = self.controlFooterViewHeightConstraint.constant
//                    self.mapView.padding.top = self.headerViewHeightConstraint.constant
//                })
//                
//                self.animationFloatView($0)
//            })
//            .addDisposableTo(bag)
        
        /**
         *  Nhận trip mới
         *  Nếu có dữ liệu pause lại, gán giá trị mới vào slider count
         */
        viewModel.tripInfo
            .asObservable()
            .filterNil()
            .do(onNext: { [unowned self] in
                self.controlFooterView.rx_playState.value = .pause
                self.controlFooterView.rx_sliderCount.value = $0.points.count - 1
            })
            /**
             *  Delay 1s trước khi chạy
             *  Đảm bảo đường lộ trình được vẽ xong, nếu ko sẽ bay app
             *  //TODO: bắt đầu cho xe chạy khi vẽ đường xong chứ ko làm kiểu delay này
             */
            .throttle(1.second, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] _ in
                self.controlFooterView.rx_playState.value = .play
                self.trackingAutomatically.onNext()
            })
            .addDisposableTo(bag)
    }
    
//    func rx_sendSignalEventsPeriodically(_ signals: [VehicleTrip.PointInfo], _ speed: TrackingControlFooterView.PlaySpeed) -> Observable<VehicleTrip.PointInfo> {
//        
//        /**
//         *  Tạo timing từ danh sách tín hiệu còn lại trong đoạn lộ trình
//         */
//        let timing = signals
//            /**
//             *  Tạo cặp giá trị (first: Bool, second: Bool) từ các điểm pointInfo liên tiếp nhau.
//             *  False: điểm bình thường
//             *  True: điểm dừng đỗ
//             */
//            .reduce([BooleanCouple]()) { (accu: [BooleanCouple], value: VehicleTrip.PointInfo) -> [BooleanCouple] in
//                return accu.count > 0 ? accu + [BooleanCouple(first: accu[accu.count - 1].second, second: value.isStopPoint)] :
//                    [BooleanCouple(first: false, second: value.isStopPoint)]
//            }
//            /**
//             *  Nếu first là điểm dừng đỗ -> nghĩa là xe đã di chuyển tới điểm dừng -> delay lại theo BaseTimeStop
//             *  Việc này để tránh trường hợp tín hiệu điểm tiếp theo là dừng đỗ mà marker xe lại dừng ở điểm trước đó
//             */
//            .map { [speed] booleanCouple -> Double in
//                return booleanCouple.first ? (AppConfig.Tracking.BaseTimeStop / speed.multiplier) : (AppConfig.Tracking.BaseTimeMoving / speed.multiplier)
//            }
//            /**
//             *  Cộng lại các khoảng thời gian để tính delaySubscription
//             */
//            .reduce([Double]()) { (accu: [Double], value: Double) -> [Double] in
//                return accu.count == 0 ? [value] : accu + [(accu[accu.count - 1] + value)]
//        }
//        
//        return Observable
//            .zip(
//                signals.toObservable(),
//                timing.toObservable()
//            ) { ($0, $1) }
//            .flatMap { point, time -> Observable<VehicleTrip.PointInfo> in
//                Observable.just(point).delaySubscription(time.second, scheduler: MainScheduler.instance)
//        }
//        
//        
//        
//        //        return Observable.zip(
//        //            signals.toObservable(),
//        //            Observable<Int>.timer(
//        //                0,
//        //                period: (0.5 / speed.multiplier).second,
//        //                scheduler: MainScheduler.instance)
//        //        ) { x, _ in x }
//        
//        
//    }
    
    func rx_cancelCarAnimationObservable() -> Observable<Void> {
        return Observable
            .of(
                controlFooterView.rx_playState.asObservable().filter { x in x == .pause }.replaceWith(),
                controlFooterView.rx_playSpeed.asObservable().skip(1).replaceWith(),
                viewModel.tripInfo.asObservable().filterNil().skip(1).replaceWith(),
                controlFooterView.rx_sliderValueChangedManually.asObservable().replaceWith()
            )
            .merge()
    }
    
    fileprivate func rx_getRemainPointsBasedOnSliderValue() -> Observable<[VehicleTrip.PointInfo]> {
        return Observable
            /**
             *  Kết hợp signal từ trip info -> [Coordinate] và vị trí Slider
             */
            .combineLatest(
                controlFooterView.rx_sliderValue.asObservable(),
                viewModel.tripInfo.asObservable().filterNil().map { $0.points }
            ) { ($0, $1) }
            .take(1)
            /**
             *  Thêm vào một giá trị kInvalidCoordinate vào cuối cùng
             *  (để check chuyển trạng thái .Play -> .Pause sau khi chạy hết lộ trình)
             */
            .map { pos, points in
                (pos, points + [VehicleTrip.PointInfo(index: 0, coordinate: kInvalidCoordinate, time: 0, velocity: 0, velocityColor: .unknown, isStopPoint: false)])
            }
            /**
             *  Tính toán thêm số lượng điểm còn lại trên lộ trình
             *  points.count - 1 -> số lượng điểm thật có
             *  points.count - 2 -> số lượng điểm thật còn lại (trừ đi điểm giả vừa được thêm vào ở trên)
             */
            .map { pos, points in
                (pos, points, points.count - pos - 2)
            }
            
            /**
             *  Nếu ko còn điểm nào (remains = 0)
             *  Thì return toàn bộ lộ trình. Đồng thời set lại giá trị slider và vị trí marker
             *  Nếu có thì return đoạn còn lại để tiếp tục chạy, đồng thời + 1 vào sliderValue
             *  *** Việc +1 này để fix lỗi xe chạy hết lộ trình mà slider chưa xong (còn 1 bước nữa)
             *  Dự đoán là do việc làm tròn từ Float -> Int của slider value.
             */
            .flatMapLatest { position, points, remains -> Observable<[VehicleTrip.PointInfo]> in
                if remains == 0 || position == 0 {
                    return points
                        .toObservable()
                        .toArray()
                        .observeOn(MainScheduler.instance)
                        .doOnNext { [unowned self] _ in
                            self.controlFooterView.rx_sliderValue.value = 0
                            self.carMarker.map = nil
                    }
                }
                return points
                    .toObservable()
                    .takeLast(remains)
                    .toArray()
                    .observeOn(MainScheduler.instance)
                    .doOnNext { [unowned self] _ in
                        self.controlFooterView.rx_sliderValue.value += 1
                }
        }
    }
    
    fileprivate func rx_createPanGestureOnMap() -> Observable<Void> {
        return Observable.create { [unowned self] observer in
            let pan = UIPanGestureRecognizer()
            pan.cancelsTouchesInView = false
            let listener = pan.rx.event
                .subscribe(onNext: { _ in
                    observer.onNext()
                    observer.onCompleted()
                })
            
            self.mapView.addGestureRecognizer(pan)
            
            return AnonymousDisposable { [weak self] in
                if let `self` = self {
                    `self`.mapView.removeGestureRecognizer(pan)
                }
                listener.dispose()
            }
        }
    }
    
}

*/
