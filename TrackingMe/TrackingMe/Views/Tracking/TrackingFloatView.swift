//
//  TrackingFloatView.swift
//  GPSMobile
//
//  Created by Nguyen Duc Nang on 5/26/16.
//  Copyright © 2016 Hoan Pham. All rights reserved.
//

import UIKit
import PHExtensions

class TrackingFloatView: UIView {
    
    fileprivate enum Size: CGFloat {
        case padding10 = 8, label = 26
    }
    
    fileprivate var dateTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = " dd/MM/yyyy"
        return formatter
    }
    
    fileprivate var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }
    
    fileprivate var labelTitleDistance: UILabel!
    fileprivate var labelDistance: UILabel!
    fileprivate var seperator: UIView!
    fileprivate var detailsView: UIView!
    
    var labelTime: UILabel!
    var labelSubTime: UILabel!
    var labelSpeed: UILabel!
    var labelSubSpeed: UILabel!
    
    /**
     Thông tin xe tại 1 thời điểm
     */
    var info: VehicleTrip.PointInfo? = nil {
        didSet {
            guard let info = info else { return }
            
            labelTime.text = timeFormatter.string(from: Date(timeIntervalSince1970:  info.time))
            labelSubTime.text = dateTimeFormatter.string(from: Date(timeIntervalSince1970: info.time))

            labelSpeed.text = "\(info.velocity)"
        }
    }
    
    /**
     Tổng lộ trình
     */
    var totalDistance: Double = 0 {
        didSet {
            
            if Utility.shared.stringFromConvertDistanceToText(totalDistance).characters.count > 0 {
                 labelDistance.text = Utility.shared.stringFromConvertDistanceToText(totalDistance)
            } else {
                labelDistance.text = "0 Km"
            }
        }
    }
    
    /**
     Mã màu
     */
    var velocityColor: UIColor = UIColor.main {
        didSet {
            labelSpeed.textColor = velocityColor
        }
    }
    
    
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
        
        labelTitleDistance.frame = CGRect(x: Size.padding10..,
                                          y: Size.padding10.. / 2,
                                          width: bounds.width - Size.padding10..  * 2,
                                          height: Size.label..)
        
        labelDistance.frame = CGRect(x: Size.padding10..,
                                     y: Size.padding10.. / 2,
                                     width: bounds.width - Size.padding10..  * 2,
                                     height: Size.label..)
        
        seperator.frame = CGRect(x: Size.padding10..,
                                 y: labelTitleDistance.frame.maxY,
                                 width: bounds.width - Size.padding10..  * 2,
                                 height: onePixel())
        
        
        detailsView.frame = CGRect(x: Size.padding10..,
                                   y: seperator.frame.maxY + Size.padding10.. / 4,
                                   width: bounds.width - Size.padding10..  * 2,
                                   height: bounds.height - seperator.frame.maxY - Size.padding10.. )
        
        

        
        labelSubSpeed.frame = CGRect(x: detailsView.frame.width - detailsView.frame.height,
                                     y: 0,
                                     width:  detailsView.frame.height,
                                     height:  Size.label.. )
        
        labelSpeed.frame = CGRect(x: detailsView.frame.width - detailsView.frame.height,
                                  y:  labelSubSpeed.frame.maxY - 2,
                                  width:  detailsView.frame.height,
                                  height:  detailsView.frame.height - Size.label.. )
        
        labelSubTime.frame = CGRect(x: 0,
                                    y: 0,
                                    width:  detailsView.frame.width  - detailsView.frame.height,
                                    height:  Size.label.. )
        
        labelTime.frame = CGRect(x: 0,
                                 y: labelSubTime.frame.maxY - 2,
                                 width:  detailsView.frame.width - detailsView.frame.height,
                                 height:  detailsView.frame.height - Size.label..)
        
        
        

        
    }
}

extension TrackingFloatView {
    fileprivate func setup() {
        
        labelTitleDistance = setupLabel(UIColor.main,
                                        text:  "Lộ trình",
                                        font: UIFont(name: FontType.latoBold.., size: FontSize.normal--)!,
                                        alignment: .left)
        
        labelDistance = setupLabel(UIColor.darkGray,
                                   font: UIFont(name: FontType.latoSemibold.., size: FontSize.small++)!,
                                   alignment: .right)
        seperator = setupView()
        detailsView = setupView(UIColor.clear)
        
        labelTime = setupLabel(font: UIFont(name: FontType.latoRegular.., size: FontSize.normal++)!,
                               alignment: .left)
        
        labelSubTime = setupLabel(UIColor.gray,
                                  font: UIFont(name: FontType.latoBlackItalic.., size: FontSize.small--)!,
                                  alignment: .left)
        
        
        labelSpeed = setupLabel(UIColor.main,
                                font: UIFont(name: FontType.latoRegular.., size: FontSize.large++)!,
                                alignment: .center)
        
        labelSubSpeed = setupLabel(UIColor.gray,
                                   text:  "Km/h",
                                   font: UIFont(name: FontType.latoBlackItalic.., size: FontSize.small--)!,
                                   alignment: .center)
        
        addSubview(labelTitleDistance)
        addSubview(labelDistance)
        addSubview(seperator)
        addSubview(detailsView)
        
        detailsView.addSubview(labelTime)
        detailsView.addSubview(labelSpeed)
        
        detailsView.addSubview(labelSubTime)
        detailsView.addSubview(labelSubSpeed)
        
        layer.cornerRadius = 3
        backgroundColor = UIColor.white.alpha(0.85)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        layer.borderWidth = onePixel()
        layer.borderColor = UIColor.lightGray.cgColor
        
        
        labelSpeed.text = "0"
        labelTime.text = "00:00:00"
        labelSubTime.text = " 00/00/0000"
        labelDistance.text = "0 Km"
        
    }
    
    fileprivate func setupLabel(_ textColor: UIColor = UIColor.darkGray,
                            text: String? = nil,
                            font: UIFont = UIFont(name: FontType.latoRegular.., size: FontSize.normal--)!,
                            alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = font
        label.textAlignment = alignment
        return label
    }
    
    fileprivate func setupView(_ bgColor: UIColor = UIColor.lightGray) -> UIView {
        let view = UIView()
        view.backgroundColor = bgColor
        return view
        }
}
