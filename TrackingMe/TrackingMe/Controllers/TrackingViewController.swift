//
//  TrackingViewController.swift
//  TrakingMe
//
//  Created by Thành Lã on 12/30/16.
//  Copyright © 2016 Bình Anh Electonics. All rights reserved.
//

import UIKit
import GoogleMaps
import SnapKit
import PHExtensions
import JGProgressHUD
import RxSwift
import RxCocoa
import CleanroomLogger
import RxExtensions

protocol TrackingViewControllerDelegate: class {
    func reloadTable()
}

protocol InspectableMarker {}

class TrackingViewController: GeneralViewController {
    
    fileprivate enum Size: CGFloat {
        case padding5 = 5, padding15 = 15, button = 44
    }
    
    let bag = DisposeBag()
    var tracking: Tracking!
    let saveTrackingSignal = PublishSubject<Void>()
        
    var mapView: GMSMapView!
    fileprivate var myLocation: MapButton!
    fileprivate var routePolyline: GMSPolyline!
    var info: UIBarButtonItem!
    
    var floatView: TrackingFloatView!
    
    var controlFooterView: TrackingControlFooterView = {
        let view = TrackingControlFooterView()
        return view
    }()
    
    var infoWindow: TrackingMarkerInfoWindow!
    
    fileprivate var floatViewLeadingConstraint: Constraint!
    fileprivate var floatViewWidthConstraint: Constraint!
    fileprivate var floatViewHeightConstraint: Constraint!
    var controlFooterViewHeightConstraint: Constraint!
    
    var trackingWhileDraggingSlider = Variable<Bool>(true)
    var trackingAutomatically = PublishSubject<Void>()
    
    var currentPosition: Int = 0
    var date: Date!
    
    var state: State = .normal
    
    enum State {
        case normal
        case tracking
    }
    
    internal var location: CLLocationCoordinate2D {
        guard let myLocation = mapView.myLocation, myLocation.coordinate.isValid else {
            return kInvalidCoordinate
        }
        return myLocation.coordinate
    }
    
    weak var delegate: TrackingViewControllerDelegate?
    
    var polyline: GMSPolyline?
    var staticMarkers: [GMSMarker] = []
    var carMarker: VehicleMarker!
    var inspectableMarkers: [InspectableMarker] = []
    var viewModel: TrackingViewModel!
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAllSubViews()
        view.setNeedsUpdateConstraints()
        
        guard state == .normal, let tracking = self.tracking else {
            rx_userMovementTracking()
            rx_updateTrackingToRealm()
            return
        }
        
        drawTracking() {
            self.zoomBoundsMap(coordinates: tracking.movements.map { $0.coordinate }, incudingMyLocation: nil)
            
        }
        
        let info = RealTimeVehicle(ID: 1,
                                   plate: "35M1.03431",
                                   coordinate: tracking.movements.map { $0.coordinate }[0],
                                   status: VehicleStatus.EngineOff,
                                   velocity: 4,
                                   driverName: "MILIKET",
                                   driverPhone: "0973360262",
                                   direction: tracking.directions[0].direction,
                                   updateTime: Date().timeIntervalSince1970,
                                   vehicleTime: Date().timeIntervalSince1970,
                                   iconCode: VehicleIcon.car,
                                   privateCode: "26626")
        
        carMarker = VehicleMarker(info: info) //viewModel.vehicleInfo)
        carMarker.zIndex = 15
        carMarker.position = tracking.movements.map { $0.coordinate }[0]
        carMarker.tracksViewChanges = true
        carMarker.map = mapView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            setupAllConstraints()
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        if state == .tracking {
            self.mapView.animate(to: GMSCameraPosition.camera(withTarget: location, zoom: 15.5))
        }
    }
}


//MARK: SELECTOR
extension TrackingViewController {
    
    func info(_ sender: UIBarButtonItem) {
        animationFloatView(floatView.frame.origin.x != 5)
        
    }
    
    func playTracking(_ sender: UIButton) {
        guard let tracking = tracking else { return }
        
        print("Coordinates: \(tracking.coordinates.count)")
        print("coupleMovement: \(tracking.coupleMovement.count)")
        print("timeArray: \(tracking.times.count)")
        print("directions: \(tracking.directions.count)")
        print("velocitysCount: \(tracking.velocitys.count)")
        print("velocitysMax: \(tracking.velocityMax)")
        print("velocitysMedium: \(tracking.velocityMedium)")
        
        let tMax = tracking.times.max()
        let tMin = tracking.times.min()
        print("time max: \(tMax) - time min: \(tMin)")
        
        mapView.animate(to: GMSCameraPosition.camera(withTarget: tracking.movements[0].coordinate, zoom: 17))
        
        guard currentPosition < tracking.movements.count - 1 else { return }
        
        date = Date().addingTimeInterval(tracking.times[currentPosition])
        
        timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(self.animationForTracking), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        
    }
    
    func saveTracking(_ sender: UIBarButtonItem) {
        
        /// Gửi tín hiệu cập nhật tracking vào DB
        saveTrackingSignal.onNext()
        
        delegate?.reloadTable()
        _ = navigationController?.popViewController(animated: true)
    }
    
    func back(_ sender: UIBarButtonItem) {
        timer.invalidate()
        _ = navigationController?.popViewController(animated: true)
    }
    
    func myLocation(_ sender: MapButton) {
        setVisibilityOf(myLocation, to: false)
        
        guard let location = mapView.myLocation, location.coordinate.isValid else  {
            HUD.showMessage("Chưa lấy được vị trí hiện tại của bạn", onView: view)
            return
        }
        animateOnMap(0.5.second, mapView.animate(toLocation: location.coordinate))
        
    }
}


//MARK: PRIVATE METHOD
extension TrackingViewController {
    
    func animationForTracking() {
        guard let marker = carMarker, let tracking = tracking else { return }
        
        guard currentPosition < tracking.movements.count - 1 else {
            
            controlFooterView.slider.value = Float(tracking.movements.count)
            currentPosition = tracking.movements.count
            return
        }
        
        
        animateOnMap(0.3.second, mapView.animate(toLocation: tracking.movements[currentPosition].coordinate))
        
        currentPosition += 1; print(self.currentPosition)
        date = Date().addingTimeInterval(tracking.times[currentPosition])
        controlFooterView.slider.setValue(Float(currentPosition), animated: true)
        
        marker.animationRotationWithDirection(tracking.directions[currentPosition].direction)
        marker.animationMarkerMoveToPosition(
            tracking.movements[currentPosition].coordinate,
            duration: tracking.times[currentPosition])
        

    }
    
    /**
     Animation di chuyển marker
     */
    func animationMarkerMoveToPosition(_ positon: CLLocationCoordinate2D, duration: TimeInterval) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        carMarker.position = positon
        CATransaction.commit()
    }
    
    
    func animationFloatView(_ visible: Bool) {
        
        if visible {
            floatView.isHidden = false
            floatViewLeadingConstraint.update(inset: 5)
        } else {
            floatViewLeadingConstraint.update(inset: -floatView.frame.width)
        }
        
        UIView.animate(withDuration: 0.4.second, animations: {
            self.view.layoutIfNeeded()
            
        }, completion: { _ in
            if !visible { self.floatView.isHidden = true }
        })
        
    }
    
    
    func drawTracking(completion: (() -> Void)? = nil) {
        
        guard let tracking = tracking else { return }
        
        switch state {
        case .normal:
            let line = TrackingPolyline(tracking: tracking)
            line.map = mapView
            
        case .tracking:
            break
        }
        
        if let completion = completion {
            delay(0.1) { completion() }
        }
        
    }
    
    func setVisibilityOf(_ view: UIView, to visible: Bool, duration: TimeInterval = 0.2, completion: (() -> Void)? = nil) {
        
        UIView.animate(
            withDuration: duration,
            animations: {
                view.alpha = visible ? 1.0 : 0.0
            },
            completion: { finished in
                if let completion = completion { completion() }
        })
        
    }
    
    func animateOnMap(_ duration: TimeInterval, _ block:@autoclosure () -> Void, _ completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setValue(duration, forKey: kCATransactionAnimationDuration)
        block()
        
        CATransaction.commit()
        if let completion = completion {
            Timer.after(duration + 0.3) { _ in // 0.3 để đảm bảo map dừng hẳn
                completion()
            }
        }
    }
    
    
    /**
     Zoom bounds Map with arrayCoordinate
     */
    
    func zoomBoundsMap(coordinates: [Coordinate], incudingMyLocation: Coordinate?, completion: (() -> Void)? = nil) {
        
        var bounds = GMSCoordinateBounds()
        coordinates.forEach { bounds = bounds.includingCoordinate($0) }
        if let coor = incudingMyLocation { bounds = bounds.includingCoordinate(coor) }
        
        var edgeInsets: UIEdgeInsets!
        switch Device.size() {
        case .screen3_5Inch:
            edgeInsets = UIEdgeInsets(top: 10, left: 45, bottom: 10, right: 45)
            
        default:
            edgeInsets = UIEdgeInsets(top: 85, left: 45, bottom: 55, right: 45)
        }
        
        
        guard let camera = mapView.camera(for: bounds, insets: edgeInsets) else { return }
        self.animateOnMap(0.3, self.mapView.animate(to: camera)) {
            if let completion = completion { completion() }
        }
    }
    
}

//MARK: GOOGLEMAP DELEGATE
extension TrackingViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//        print(position.zoom)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        setVisibilityOf(myLocation, to: true)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        animateOnMap(0.3, mapView.animate(toLocation: marker.position)) {
            mapView.selectedMarker = marker
        }
        return true
    }
    
//    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
//        
//        let name = "MILIKET"
//        let descriptions = "WaveRS. 35M1-03431"
//        
//        let titleWith = Utility.shared.widthForView(text: name,
//                                                    font: UIFont(name: FontType.latoSemibold.., size: 14)!,
//                                                    height: 16)
//        
//        let subWith = Utility.shared.widthForView(text: descriptions,
//                                                  font: UIFont(name: FontType.latoRegular.., size: 13)!,
//                                                  height: 16)
//        let with = max(titleWith, subWith)
//        
//        let infoWindow = InforMarkerView()
//        infoWindow.frame = CGRect(x: 0, y: 0, width: max(100, with) + Size.padding15.., height: 90)
//        
//        infoWindow.avatar.avatarImage.image = Icon.Tracking.avatar
//        infoWindow.title.text = name
//        infoWindow.descriptions.text = descriptions
//        return infoWindow
//    }
    
}

//MARK: SETUP VIEW
extension TrackingViewController {
    
    fileprivate func setupAllSubViews() {
        
        UIApplication.shared.statusBarStyle = .default
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isTranslucent = false
                
        setupMapView()
        setupBarButton()
        setupMyLocation()
        setupInfoWindow()
        setupFloatView()
        setupFooterView()
        
        
        if let tracking = tracking {
            title = tracking.name
        }
    }
    
    fileprivate func setupAllConstraints() {
        
        controlFooterView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalTo(view)
            make.height.equalTo(state == .normal ? 54 : 0)
        }
        
        mapView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view)
            make.bottom.equalTo(controlFooterView.snp.top)
        }
        
        myLocation.snp.makeConstraints { (make) in
            make.height.equalTo(Size.button..)
            make.width.equalTo(Size.button..)
            make.right.equalTo(view.snp.right).inset(Size.padding15..)
            make.bottom.equalTo(controlFooterView.snp.top).offset(-Size.padding15..)
        }
        
        floatView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).inset(5)
            floatViewLeadingConstraint = make.leading.equalTo(view.snp.leading).inset(5).constraint
            floatViewWidthConstraint = make.width.equalTo(160).constraint
            floatViewHeightConstraint = make.height.equalTo(85).constraint
        }
        
    }
    
    fileprivate func setupMapView() {
        mapView = GMSMapView()
        mapView.delegate = self
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.mapType = kGMSTypeNormal
        
        view.addSubview(mapView)
    }
    
    fileprivate func setupBarButton() {
        switch state {
        case .normal:
            let left = UIBarButtonItem(image: Icon.Nav.Back, style: .plain, target: self, action: #selector(self.back(_:)))
            left.tintColor = .white
            navigationItem.leftBarButtonItem = left
            
            info = UIBarButtonItem(image: Icon.Nav.info, style: .plain, target: self, action: #selector(self.info(_:)))
            info.tintColor = .white
            navigationItem.rightBarButtonItem = info
            
        case .tracking:
            let left = UIBarButtonItem(image: Icon.Nav.Done, style: .plain, target: self, action: #selector(self.saveTracking(_:)))
            left.tintColor = .white
            navigationItem.leftBarButtonItem = left
        }
    }
    
    fileprivate func setupMyLocation() {
        myLocation = MapButton()
        myLocation.setImage(Icon.General.myLocation.tint(UIColor.main), for: UIControlState())
        myLocation.addTarget(self, action: #selector(self.myLocation(_:)), for: .touchUpInside)
        view.addSubview(myLocation)
    }
    
    fileprivate func setupInfoWindow() {
        infoWindow = TrackingMarkerInfoWindow()
        infoWindow.frame = CGRect(x: 0, y: 0, width: 230, height: 65)
    }

    fileprivate func setupFloatView() {
        floatView = TrackingFloatView()
        view.addSubview(floatView)
        
        guard let tracking = tracking else { return }
        
        floatView.totalDistance = tracking.totalDistance
        
        floatView.info = VehicleTrip.PointInfo(index: 1,
                                               coordinate: tracking.movements[0].coordinate,
                                               time: tracking.convertToRealmType().time,
                                               velocity: Int(tracking.velocityMedium),
                                               velocityColor: LineSegment.Category.normal,
                                               isStopPoint: false)
        
        floatView.labelTime.text = Utility.shared.stringMinuteFromTimeInterval(tracking.totalTime)
        
    }
    
    fileprivate func setupFooterView() {
        controlFooterView = TrackingControlFooterView()
        controlFooterView.buttonPlay.addTarget(self, action: #selector(self.playTracking(_:)), for: .touchUpInside)
        view.addSubview(controlFooterView)
    }
    
}



