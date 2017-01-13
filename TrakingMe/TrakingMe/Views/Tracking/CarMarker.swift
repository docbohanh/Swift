//
//  DeviceMarker.swift
//  TrakingMe
//
//  Created by Thành Lã on 1/13/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import Foundation
import UIKit
import PHExtensions
import GoogleMaps
//import GPSNetwork
////import Async

class CarMarker: GMSMarker {
    
    
    fileprivate enum Size: CGFloat {
        case width = 70, height = 50, padding10 = 10
    }
    
    var info: VehicleOnline! {
        didSet {
            self.tracksViewChanges = false
            self.isTappable = true
            self.isFlat = false
            self.groundAnchor = CGPoint(x: 0.5, y: 1.0)
            self.position = info.coordinate
                                    
            self.craMarkerView = self.setupIconView()
            self.iconView = self.craMarkerView
        }
    }
    
    var durationRotation = 0.5.second
    var durationMove = 5.seconds
    
    var selected: Bool =  false {
        didSet {
            self.tracksViewChanges = true
            if selected {
                craMarkerView.label.backgroundColor = UIColor.main
                craMarkerView.label.textColor = UIColor.white
                craMarkerView.label.layer.borderColor = UIColor.white.cgColor
            } else {
                craMarkerView.label.backgroundColor = UIColor.white.alpha(0.85)
                craMarkerView.label.textColor = UIColor.black.alpha(0.8)
                craMarkerView.label.layer.borderColor = UIColor.lightGray.cgColor
            }
            self.tracksViewChanges = false
        }
    }
    
    
    fileprivate var craMarkerView: CarMarkerView!
    
    init(info: VehicleOnline) {
        
        self.info = info
        
        super.init()
        self.tracksViewChanges = false
        self.isTappable = true
        self.isFlat = true
        self.groundAnchor = CGPoint(x: 0.5, y: 0.66)
        self.position = info.coordinate
        
        self.craMarkerView = self.setupIconView()
        self.iconView = self.craMarkerView
        
    }
    
    func updateMarkerInfo(_ info: VehicleOnline, moveDuration: TimeInterval = 5.seconds, rotateDuration: TimeInterval = 2.seconds) {
        self.tracksViewChanges = true
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(moveDuration)
        `self`.position = info.coordinate
        CATransaction.commit()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + moveDuration + 0.1.seconds) { [weak self] in
            guard let `self` = self else { return }
            `self`.info = info
            `self`.tracksViewChanges = false
        }
        
    }
    
    
    
    fileprivate func setupIconView(_ plate: String = "35M1-034.31") -> CarMarkerView {
        //TODO: setup view có label là plate
        // có marker xe dựa vào trạng thái xe
        
        let name = "35M1-034.31"
        let width = Size.padding10.. + Utility.shared.widthForView(text: name.uppercased(),
                                                                   font: UIFont(name: FontType.latoSemibold..,
                                                                                size: FontSize.small..)!,
                                                                   height: 25)
        
        let view = CarMarkerView(frame: CGRect(x: 0, y: 0, width: width, height: Size.height..))
        view.label.text = plate.uppercased()
        view.image.image = UIImage(named: "motorcycle_blue_0")
        return view
    }
    
    /**
     Animation quay marker với góc "direction"
     */
    func animationRotationWithDirection(_ direction: CLLocationDegrees) {
        UIView.animate(withDuration: durationRotation, animations: { _ in
            self.craMarkerView.image.transform = CGAffineTransform(rotationAngle: CGFloat(direction) / 180 * CGFloat(M_PI))
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
    
    
}


private class CarMarkerView: UIView {
    
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
