//
//  TrackingViewController+Setup.swift
//  TrakingMe
//
//  Created by Thành Lã on 1/13/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import UIKit
import SnapKit
import GoogleMaps
import PHExtensions

//MARK: SETUP VIEW
extension TrackingViewController {
    
    func setupAllSubViews() {
        
        UIApplication.shared.statusBarStyle = .default
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isTranslucent = false
        
        setupMapView()
        setupBarButton()
        setupMyLocation()
        setupStartTracking()
        startTracking.isEnabled = false
        startTracking.alpha = 0
        
        setupFloatView()
        setupFooterView()
                
        if let tracking = tracking {
            title = tracking.name
        }
    }
    
    func setupAllConstraints() {
        
        footerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.height.equalTo(state == .normal ? 58 : 0)
            footerViewBottomConstraint = make.bottom.equalTo(view).constraint
        }
        
        mapView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view)
            make.bottom.equalTo(footerView.snp.top)
        }
        
        myLocation.snp.makeConstraints { (make) in
            make.width.height.equalTo(Size.button..)
            make.right.equalTo(view.snp.right).inset(Size.padding15..)
            make.bottom.equalTo(footerView.snp.top).offset(-Size.padding15..)
        }
        
        startTracking.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(view)
            make.width.height.equalTo(64)
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
            
            let left = setupBarButton(image: Icon.Nav.Back, selector: #selector(self.back(_:)), target: self)
            navigationItem.leftBarButtonItem = left
            
            infoFloatView = setupBarButton(image: Icon.Nav.info, selector: #selector(self.infoFloatView(_:)), target: self)
            deleteTracking = setupBarButton(image: Icon.Nav.Trash, selector: #selector(self.deleteTracking(_:)), target: self)
            navigationItem.rightBarButtonItems = [deleteTracking, infoFloatView]
            
        case .tracking:
            let left = UIBarButtonItem(image: Icon.Nav.Back, style: .plain, target: self, action: #selector(self.save(_:)))
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
    
    func setupStartTracking() {
        startTracking = MapButton()
        startTracking.setTitle("Start", for: UIControlState())
        startTracking.titleLabel?.font = UIFont(name: FontType.latoSemibold.., size: FontSize.large..)
        startTracking.setTitleColor(UIColor.main, for: UIControlState())
        startTracking.addTarget(self, action: #selector(self.startTracking(_:)), for: .touchUpInside)
        view.addSubview(startTracking)
    }
    
    fileprivate func setupFloatView() {
        floatView = TrackingFloatView()
        view.addSubview(floatView)
        
        guard let tracking = tracking, tracking.movements.count > 0 else { return }
        floatView.totalDistance = tracking.totalKm * 1_000
        
        floatView.info = VehicleTrip.PointInfo(index: 1,
                                               coordinate: tracking.movements[0].coordinate,
                                               time: tracking.movements[0].timestamp,
                                               velocity: Int(tracking.velocityMedium),
                                               isStopPoint: false)
        
        floatView.labelTime.text = Utility.shared.stringMinuteFromTimeInterval(tracking.totalTime)
        
        
    }
    
    fileprivate func setupFooterView() {
        footerView = TrackingControlFooterView()
        footerView.delegate = self
        view.addSubview(footerView)
    }
    
    
    func setupCarMarker() {
        
        carMarker = CarMarker(info: vehicleOnline)

        carMarker?.map = mapView
        carMarker?.zIndex = 1000
        mapView.selectedMarker = carMarker
        guard let tracking = tracking else { return }
        carMarker?.animationRotationWithDirection(tracking.directions[0].direction)
    }
    
    
    
    func setupStopPointMarker(_ position: CLLocationCoordinate2D, icon: UIImage = Icon.Tracking.Stop) -> GMSMarker {
        let marker = GMSMarker(position: position)
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        marker.icon = icon
        marker.map = mapView
        marker.zIndex = 0
        return marker
    }
    
    func setupPointMarker(_ position: CLLocationCoordinate2D, icon: UIImage, zIndex: Int = 0) -> GMSMarker {
        let marker = GMSMarker(position: position)
        marker.groundAnchor = CGPoint(x: 0.5, y: 1.0)
        marker.icon = icon
        marker.map = mapView
        marker.zIndex = Int32(zIndex)
        return marker
    }
    
}
