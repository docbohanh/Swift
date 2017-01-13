//
//  VehicleMarker.swift
//  TrakingMe
//
//  Created by Thành Lã on 1/6/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import UIKit
import PHExtensions
import GoogleMaps

class VehicleMarker: GMSMarker {
    
    
    var xAxis: Double {
        return self.position.longitude
    }
    
    var yAxis: Double {
        return self.position.latitude
    }
    
    fileprivate enum Size: CGFloat {
        case width = 70, height = 50
    }
    
    var info: RealTimeVehicle
    
    /**
     Kh
     */
    var durationRotation = 0.5.second
    var durationMove = 5.seconds
    
    var direction: CLLocationDegrees = 0.0 {
        didSet {
            animationRotationWithDirection(direction)
        }
    }
    
    var selected: Bool =  false {
        didSet {
            if selected {
                carMarker.label.backgroundColor = UIColor.main
                carMarker.label.textColor = UIColor.white
                carMarker.label.layer.borderColor = UIColor.white.cgColor
            } else {
                carMarker.label.backgroundColor = UIColor.white
                carMarker.label.textColor = UIColor.black.alpha(0.8)
                carMarker.label.layer.borderColor = UIColor.gray.cgColor
            }
        }
    }
    
    
    fileprivate var carMarker: CarMarker!
    
    init(info: RealTimeVehicle) {
        let direction = CLLocationDegrees(info.direction)
        self.info = info
        self.direction = direction
        
        
        super.init()
        self.tracksViewChanges = false
        self.isTappable = true
        self.isFlat = true
        self.groundAnchor = CGPoint(x: 0.5, y: 0.66)
        self.position = info.coordinate
        self.direction = direction
        self.carMarker = self.setupIconView(info.plate, status: info.status, direction: direction)
        self.iconView = self.carMarker
        //        self.icon = Utility.carMarkerWithText(marker: image, text: info.plate)
        self.carMarker.image.transform = CGAffineTransform(rotationAngle: CGFloat(direction) / 180 * CGFloat(M_PI))
    }
    
    func updateMarkerInfo(_ info: RealTimeVehicle, moveDuration: TimeInterval = 5.seconds, rotateDuration: TimeInterval = 2.seconds) {
        self.tracksViewChanges = true
        UIView.animate(withDuration: rotateDuration, animations: { [weak self] in
            guard let `self` = self else { return }
            let heading = GMSGeometryHeading(`self`.position, info.coordinate)
            `self`.carMarker.image.transform = CGAffineTransform(rotationAngle: CGFloat(heading) / 180 * CGFloat(M_PI))
        })
        
        //        UIView.animateWithDuration(moveDuration) { [weak self] in
        //            guard let `self` = self else { return }
        //            `self`.position = info.coordinate
        //        }
        CATransaction.begin()
        CATransaction.setAnimationDuration(moveDuration)
        `self`.position = info.coordinate
        CATransaction.commit()
        
        delay(moveDuration + 0.1.seconds) { [weak self] in
            guard let `self` = self else { return }
            `self`.info = info
            `self`.tracksViewChanges = false
        }
    }
    
    func animateMarkerForTracking(_ position: CLLocationCoordinate2D, moveDuration: TimeInterval, rotateDuration: TimeInterval) {
        UIView.animate(withDuration: rotateDuration, animations: { [weak self] in
            guard let `self` = self else { return }
            let heading = GMSGeometryHeading(`self`.position, position)
            
            if `self`.info.iconColor == .lostGPS {
                `self`.carMarker.image.transform = CGAffineTransform.identity
            } else {
                `self`.carMarker.image.transform = CGAffineTransform(rotationAngle: CGFloat(heading) / 180 * CGFloat(M_PI))
            }
        })
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(moveDuration)
        `self`.position = position
        CATransaction.commit()
    }
    
    
    fileprivate func setupIconView(_ plate: String, status: VehicleStatus, direction: CLLocationDegrees) -> CarMarker {
        //TODO: setup view có label là plate
        // có marker xe dựa vào trạng thái xe
        let view = CarMarker(frame: CGRect(x: 0, y: 0, width: Size.width.., height: Size.height..))
        view.label.text = plate.uppercased()
        view.image.image = self.info.getVehicleImage()
        
        return view
    }
    
    /**
     Animation quay marker với góc "direction"
     */
    func animationRotationWithDirection(_ direction: CLLocationDegrees) {
        UIView.animate(withDuration: durationRotation, animations: { _ in
            self.carMarker.image.transform = CGAffineTransform(rotationAngle: CGFloat(direction) / 180 * CGFloat(M_PI))
        })
    }
    
    
    /**
     Animation di chuyển marker
     */
    func animationMarkerMoveToPosition(_ positon: CLLocationCoordinate2D, duration: TimeInterval) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        
        self.position = positon
        CATransaction.commit()
    }
    
    /**
     Animation changed status marker
     */
    
    func animationMarkerChangedStatus(_ status: CLLocationCoordinate2D) {
        UIView.animate(withDuration: 0.3, animations: { _ in
            //            self.position = positon
            
            self.carMarker.image.image = Icon.Home.Favorite
        })
    }
    
    
    /**
     Update icon xe (Màu)
     */
    func updateMarkerColor() {
        self.carMarker.image.image = self.info.getVehicleImage()
    }
    
    
    func changeImageWithCategory(_ category: LineSegment.Category) {
        
        let iconColor: VehicleColor!
        
        switch category {
        case .normal: // xanh
            iconColor = .normalSpeed
            
        case .highSpeed: // cam
            iconColor = .highSpeed
            
        case .speeding: // đỏ
            iconColor = .speeding
            
        case .stop: // xám
            iconColor = .stop
            
        default:
            return
        }
        
        self.carMarker.image.image = UIImage(named: self.info.iconCode.name + "_" + iconColor.name + "_0") ?? Icon.Tracking.car
    }
    
}


private class CarMarker: UIView {
    
    fileprivate enum Size: CGFloat {
        case label = 18, image = 32
    }
    
    var label: UILabel!
    var image: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        image.frame = CGRect(x: (bounds.width - Size.image.. ) / 2,
                             y: bounds.height - Size.image..,
                             width: Size.image..,
                             height: Size.image..)
        
        label.frame = CGRect(x: 0, y: 0, width: bounds.width, height: Size.label..)
    }
    
    
    func setup() {
        label = setupLabel()
        image = setupImageView()
        
        addSubview(label)
        addSubview(image)
    }
    
    func setupLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: FontType.latoBold.., size: FontSize.small..)
        label.backgroundColor = UIColor.white.alpha(0.9)
        label.textColor = UIColor.darkText
        label.layer.cornerRadius = 3
        label.clipsToBounds = true
        label.textAlignment = .center
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.borderWidth = onePixel()
        return label
    }
    
    func setupImageView() -> UIImageView {
        let image = UIImageView()
        image.contentMode = .center
        return image
    }
}

