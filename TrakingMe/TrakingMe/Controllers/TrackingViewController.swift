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
    
    enum Size: CGFloat {
        case padding5 = 5, padding15 = 15, button = 44
    }
    
    let bag = DisposeBag()
    var tracking: Tracking!
    let saveTrackingSignal = PublishSubject<Void>()
        
    var mapView: GMSMapView!
    var myLocation: MapButton!
    var startTracking: MapButton!    
    var infoFloatView: UIBarButtonItem!
    var deleteTracking: UIBarButtonItem!
    
    var floatView: TrackingFloatView!
    
    var footerView: TrackingControlFooterView!    
    
    var floatViewLeadingConstraint: Constraint!
    var floatViewWidthConstraint: Constraint!
    var floatViewHeightConstraint: Constraint!
    var footerViewBottomConstraint: Constraint!
    
    /// VAR
    
    var currentPosition: Int = 0
    
    var trackingWhileDraggingSlider: Bool = true
    
    var vehicleOnline: VehicleOnline!
    
    var carMarker: CarMarker?
    
    var polyline: TrackingPolyline?
    
    var vehicleTrip: VehicleTrip?
    
    var stopPointMarker: [GMSMarker] = []
    
    var state: State = .normal
    
    var timer = Timer()
    
    enum State {
        case normal
        case tracking
    }
    
    enum AlertType {
        case deleteTracking
        
        var alertTitle: String {
            switch self {
            case .deleteTracking:
                return "Xóa lộ trình"
            }
        }
        
        var alertMessage: String {
            switch self {
            case .deleteTracking:
                return "Bạn có đồng ý xóa lộ trình này không?"
            }
        }
    }
    
    internal var location: CLLocationCoordinate2D {
        guard let myLocation = mapView.myLocation, myLocation.coordinate.isValid else {
            return kInvalidCoordinate
        }
        return myLocation.coordinate
    }
    
    weak var delegate: TrackingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAllSubViews()
        view.setNeedsUpdateConstraints()
        
        guard state == .normal, let tracking = self.tracking else {
            startTracking.isEnabled = true
            startTracking.alpha = 1
            return
        }
        
//        drawTracking() {
//            self.zoomBoundsMap(coordinates: tracking.movements.map { $0.coordinate }, incudingMyLocation: nil)
//            self.setupCarMarker()
//        }
        
        self.zoomBoundsMap(coordinates: tracking.movements.map { $0.coordinate }, incudingMyLocation: nil)
        self.setupCarMarker()
        
        
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
        else {
            animateOnMap(0.3.second, mapView.animate(to: GMSCameraPosition.camera(withTarget: tracking.coordinates[0], zoom: 16))) {
                self.animationForTracking()
            }
        }
        
    }
}


//MARK: SELECTOR
extension TrackingViewController {
    
    func infoFloatView(_ sender: UIBarButtonItem) {
        
        animationFloatView(floatView.frame.origin.x != 5)
        
    }
    
    func deleteTracking(_ sender: UIBarButtonItem) {
//        guard let tracking = tracking else { return }
//        
//        HUD.showHUD("Đang xóa") {
//            DatabaseSupport.shared.deleteTracking(id: tracking.id)
//            self.delegate?.reloadTable()
//            _ = self.navigationController?.popViewController(animated: true)
//            HUD.dismissHUD()
//        }
        showAlertController(.deleteTracking)
    }
    
    func save(_ sender: UIBarButtonItem) {
        
        saveTracking { 
            delay(1.second) {_ = self.navigationController?.popViewController(animated: true)}
        }
    }
    
    func back(_ sender: UIBarButtonItem) {
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
    
    func startTracking(_ sender: MapButton) {
        setVisibilityOf(startTracking, to: false)
        rx_userMovementTracking()
        rx_updateTrackingToRealm()
    }
}


//MARK: PRIVATE METHOD
extension TrackingViewController {
    
    func showAlertController(_ type: AlertType) {
        alertController = UIAlertController(title: type.alertTitle, message: type.alertMessage, preferredStyle: .alert)
        
        switch type {
        case .deleteTracking:
            alertController?.addAction(UIAlertAction(title: "OK", style: .default, handler: { [unowned self] _ in
                guard let tracking = self.tracking else { return }
                
                HUD.showHUD("Đang xóa") {
                    DatabaseSupport.shared.deleteTracking(id: tracking.id)
                    self.delegate?.reloadTable()
                    _ = self.navigationController?.popViewController(animated: true)
                    HUD.dismissHUD()
                }
            }))
            
            alertController?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        }
        
        present(alertController!, animated: true, completion: nil)
    }
    
    func saveTracking(complete: (() -> Void)? = nil) {
        
        /// Gửi tín hiệu cập nhật tracking vào DB
        saveTrackingSignal.onNext()
        delegate?.reloadTable()
        if let complete = complete {
            complete()
        }
    }
    
    func animationForTracking() {
        
        guard let tracking = tracking, let vehicleTrip = vehicleTrip, vehicleTrip.points.count > 0 else {
            
            self.vehicleTrip = nil
            floatView.info = nil
            floatView.totalDistance = 0
            footerView.sliderCount = 0
            //            floatViewLeadingConstraint.update(offset: -140)
            //            footerViewBottomConstraint.update(offset: 158)
            
            navigationItem.rightBarButtonItem = nil
            UIView.animate(withDuration: 0.3.second, animations: { self.view.layoutSubviews() })
            
            animationFloatView(false)
            return
        }
        
        currentPosition = 0
        
        drawPolyline(vehicleTrip.path)        
        
        print("vehicleTrip.stopPoints: \(vehicleTrip.stopPoints.count)")
        
        stopPointMarker = vehicleTrip.stopPoints.map { setupStopPointMarker($0.startCoordinate) }
        
        stopPointMarker.insert(setupPointMarker(vehicleTrip.points[0].coordinate,
                                                icon: Icon.Tracking.Start,
                                                zIndex: 2), at: 0)
        stopPointMarker.append(setupPointMarker(vehicleTrip.points[vehicleTrip.points.count - 1].coordinate,
                                                icon: Icon.Tracking.End,
                                                zIndex: 2))
        
        
        /**
         Đẩy thông tin vào float view và FooterView
         */
        floatView.info = vehicleTrip.points[currentPosition]
        floatView.totalDistance = vehicleTrip.totalDistance * 1000
        footerView.sliderCount = vehicleTrip.points.count
        animationFloatView(true)
        
        /**
         Xử lý view
         */
        
        floatViewLeadingConstraint.update(offset: 5)
        footerViewBottomConstraint.update(offset: 0)
        
        navigationItem.rightBarButtonItems = [deleteTracking, infoFloatView]
        UIView.animate(withDuration: 0.3.second, animations: { self.view.layoutSubviews() })
        
        /**
         Gán giá trị
         */
        footerView.slider.setValue(Float(0), animated: true)
        self.footerView.playState = .play
        
        animationMoveMarkerToPosition(
            vehicleTrip.points[currentPosition].coordinate,
            time: vehicleTrip.timeArray[currentPosition],
            direction: tracking.directions[currentPosition].direction)
        
        
    }

    /// Animation di chuyển Marker
    func animationMoveMarkerToPosition(_ position: CLLocationCoordinate2D, time: TimeInterval, direction: CLLocationDegrees) {
        
        if carMarker == nil { setupCarMarker() }
        
        let duration = 0.5 / footerView.playSpeed.multiplier
        
        print("duration: \(duration)")
        self.carMarker?.animationMarkerMoveToPosition(position, duration: duration) {
            self.carMarker?.animationRotationWithDirection(direction)
        }
        
        if self.trackingWhileDraggingSlider {
            self.animateOnMap(duration, self.mapView.animate(toLocation: position))
        }
        
        guard case .play = self.footerView.playState else { return }
        
        Timer.after(duration) { [weak self] _ in
            
            guard let `self` = self else { return }
            
            guard let tracking = self.tracking else { return }
            
            guard let vehicleTrip = self.vehicleTrip else {
                return
            }
            
            guard self.currentPosition < vehicleTrip.points.count - 1 else {
                self.footerView.playState = .pause
                self.footerView.slider.value = Float(vehicleTrip.points.count)
                self.currentPosition = vehicleTrip.points.count
                return
            }
            
            self.currentPosition += 1
            self.footerView.slider.setValue(Float(self.currentPosition), animated: true)
            guard case .play = self.footerView.playState else { return }
            
            self.animationMoveMarkerToPosition(
                vehicleTrip.points[self.currentPosition].coordinate,
                time: vehicleTrip.timeArray[self.currentPosition],
                direction: tracking.directions[self.currentPosition].direction)
            
            self.floatView.info = vehicleTrip.points[self.currentPosition]
            
        }
        
        
        
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
    
    /// Vẽ Polyline trên Map
    func drawPolyline(_ path: GMSPath) {
        
        polyline = TrackingPolyline(tracking: tracking)
        polyline?.map = mapView
    }
    
    
    
    // Theo dõi và bỏ theo dõi
    func tracking(_ sender: MapButton) {
        sender.isSelected = !sender.isSelected
        trackingWhileDraggingSlider = !trackingWhileDraggingSlider
    }
    
    fileprivate func animationFloatView(_ visible: Bool) {
        
        if visible {
            floatView.isHidden = false
            floatViewLeadingConstraint.update(offset: 5)
        } else {
            floatViewLeadingConstraint.update(offset: -floatView.frame.width)
        }
        
        UIView.animate(withDuration: 0.4.second, animations: {
            self.view.layoutSubviews()
            
        }, completion: { _ in
            if !visible { self.floatView.isHidden = true }
        })
        
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


extension TrackingViewController: TrackingControlFooterViewDelegate {
    func changedPlayState() {
        switch footerView.playState {
        case .play:
            
            guard let tracking = tracking, let vehicleTrip = vehicleTrip else { return }
            if currentPosition >= vehicleTrip.points.count {
                currentPosition = 0
                footerView.slider.value = 0
            }
            animationMoveMarkerToPosition(
                vehicleTrip.points[currentPosition].coordinate,
                time:  vehicleTrip.timeArray[currentPosition],
                direction: tracking.directions[currentPosition].direction)
        default:
            break
        }
    }
    
    func sliderValueChangedManually(_ value: Int) {
        
        guard let vehicleTrip = vehicleTrip else { return }
        guard value < vehicleTrip.points.count - 1 else {
            footerView.playState = .pause
            currentPosition = vehicleTrip.points.count - 1
            return
        }
        
        currentPosition = value
        carMarker?.animationMarkerMoveToPosition(vehicleTrip.points[currentPosition].coordinate, duration: 0.second)
        animateOnMap(0.second, mapView.animate(toLocation: vehicleTrip.points[currentPosition].coordinate))
        floatView.info = vehicleTrip.points[currentPosition]
        
    }
}



