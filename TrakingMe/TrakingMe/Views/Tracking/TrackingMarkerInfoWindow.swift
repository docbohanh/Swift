//
//  TrackingMarkerInfoWindow.swift
//  GPSMobile
//
//  Created by Nguyen Duc Nang on 5/23/16.
//  Copyright © 2016 Hoan Pham. All rights reserved.
//

import UIKit
import PHExtensions

class TrackingMarkerInfoWindow: UIView {
    
    fileprivate enum Size: CGFloat {
        case padding10 = 10, label = 25
    }
    
    enum State {
        case none
        case detailsStopPoint(TrackingStopPoint)
        case detailsLostGSMPoint(TrackingGSMPoint)
        case detailsReceivedGSMPoint(TrackingGSMPoint)
    }
    
    fileprivate var dateTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd/MM/yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 7)
        return formatter
    }
    
    fileprivate var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: 7)
        return formatter
    }
    
    
    var cornerRadius: CGFloat = 5
    var bgColor: UIColor = UIColor.white.withAlphaComponent(0.9)
    var isStroke: Bool = true
    
    var labelOne: UILabel!
    var labelTwo: UILabel!
    
    var state: State = .none {
        didSet {
            switch state {
            case .none:
                labelOne.text = ""
                labelTwo.text = ""
                
            case .detailsStopPoint(let stopPoint):
                
                labelOne.text = "Bắt đầu dừng: " + dateTimeFormatter.string(from: Date(timeIntervalSince1970: stopPoint.time)) 
                labelTwo.text = "Thời gian dừng: " + Utility.shared.stringMinuteFromTimeInterval(stopPoint.duration)
                
            case .detailsLostGSMPoint(let gsmPoint):
                
                labelOne.text = "Mất tín hiệu lúc: " + dateTimeFormatter.string(from: Date(timeIntervalSince1970: gsmPoint.time))
                labelTwo.text = "Thời gian mất: " + Utility.shared.stringMinuteFromTimeInterval(gsmPoint.duration)
                
            case .detailsReceivedGSMPoint(let gsmPoint):
                labelOne.text = "Có tín hiệu lúc: " + dateTimeFormatter.string(from: Date(timeIntervalSince1970: gsmPoint.time))
                labelTwo.text = "Thời gian mất: " + Utility.shared.stringMinuteFromTimeInterval(gsmPoint.duration)
            }
            
            layoutSubviews()
        }
    }

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init(radius: CGFloat, background: UIColor, isStroke: Bool) {
        self.init()
        cornerRadius = radius
        bgColor = background
        self.isStroke = isStroke
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func draw(_ rect: CGRect) {
        
        var frame = rect
        frame.origin.x += 1
        frame.origin.y += 1
        frame.size.width -= 2
        frame.size.height -= 9
        
        let windows = UIBezierPath(roundedRect: frame, cornerRadius: cornerRadius == 0 ? 5 : cornerRadius)
        
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x: frame.midX - 12 / 2, y: frame.height + 1))
        arrowPath.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        arrowPath.addLine(to: CGPoint(x: frame.midX + 12 / 2, y: frame.height + 1))
        windows.append(arrowPath)
        
        
        if isStroke {
            windows.lineWidth = onePixel()
            UIColor.black.withAlphaComponent(0.3).setStroke()
            windows.stroke()
        }
        
        bgColor.setFill()
        windows.fill()
        
        super.draw(rect)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        
//        let widthLabelOne = Utility.widthForView( labelOne.text ?? "",
//                                                  font: UIFont(name: FontType.LatoRegular.., size: FontSize.Small++)!,
//                                                  height: 25)
//        
//        let widthLabelTwo = Utility.widthForView( labelTwo.text ?? "",
//                                                  font: UIFont(name: FontType.LatoRegular.., size: FontSize.Small++)!,
//                                                  height: 25)
//        
//        bounds = CGRect(x: 0,
//                        y: 0,
//                        width: max(widthLabelOne, widthLabelTwo) + 10 * 2,
//                        height:  viewHeight())
        


        
        
        labelOne.frame = CGRect(x: Size.padding10..,
                                y: Size.padding10.. / 2,
                                width: bounds.width  - Size.padding10..,
                                height: Size.label..)
        
        labelTwo.frame = CGRect(x: Size.padding10..,
                                y: labelOne.frame.maxY,
                                width: bounds.width - Size.padding10..,
                                height: Size.label..)
        
//        drawRect(bounds)
        
    }
}

extension TrackingMarkerInfoWindow {
    
    func setup() {
        
        backgroundColor = UIColor.clear
        
        labelOne = setupLabel()
        labelTwo = setupLabel()
        
        addSubview(labelOne)
        addSubview(labelTwo)
        
    }
    
    fileprivate func setupLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: FontType.latoRegular.., size: FontSize.small++)
        label.textColor = UIColor.darkGray
        label.numberOfLines =  1
        label.textAlignment = .left
        return label
    }
    
    func viewHeight() -> CGFloat {
        return Size.padding10.. / 2 + Size.label.. + Size.label.. + Size.padding10.. / 2 + Size.padding10..
    }
    
    func viewWidth() -> CGFloat {
        
        let widthLabelOne = Utility.shared.widthForView(text: labelOne.text ?? "",
                                                  font: UIFont(name: FontType.latoRegular.., size: FontSize.small++)!,
                                                  height: Size.label..)
        
        let widthLabelTwo = Utility.shared.widthForView(text: labelTwo.text ?? "",
                                                  font: UIFont(name: FontType.latoRegular.., size: FontSize.small++)!,
                                                  height: Size.label..)
        
        return  max(widthLabelOne, widthLabelTwo) + 10 * 2;
    }
}
