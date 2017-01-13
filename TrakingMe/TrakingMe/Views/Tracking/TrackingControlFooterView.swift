//
//  TrackingControlFooterView.swift
//  GPSMobile
//
//  Created by Nguyen Duc Nang on 5/20/16.
//  Copyright © 2016 Hoan Pham. All rights reserved.
//

import UIKit
import PHExtensions
import RxSwift

protocol TrackingControlFooterViewDelegate: class {
    func sliderValueChangedManually(_ value: Int)
    func changedPlayState()
}

class TrackingControlFooterView: UIView {
    
    
    fileprivate enum Size: CGFloat {
        case padding10 = 10, padding15 = 15, button = 44, padding7 = 7, label = 30
    }
    
    enum PlaySpeed: Int {
        case speed1X = 1
        case speed2X = 2
        case speed4X = 4
        case speed8X = 8
        
        var multiplier: TimeInterval {
            return TimeInterval(self.rawValue)
        }
    }
    
    enum PlayState: Int {
        case play
        case pause
        
        func getImageForState() -> UIImage {
            switch self {
            case .pause:
                return Icon.Tracking.Play.tint(UIColor.white)
            case .play:
                return Icon.Tracking.Pause.tint(UIColor.white)
            }
        }
    }
    
    fileprivate var seperator: UIView!
    
    weak var delegate: TrackingControlFooterViewDelegate?
    
    var playSpeed: PlaySpeed = .speed2X
    
    var playState: PlayState = .pause {
        didSet {
            buttonPlay.setImage(playState.getImageForState(), for: UIControlState())
            delegate?.changedPlayState()
        }
    }
    
    var sliderCount: Int = 10 {
        didSet {
            slider.maximumValue = Float(sliderCount)
        }
    }
    
    var sliderValue: Int = 0
    
    var slider: UISlider!
    var buttonPlay: ButtonBorder!
    var buttonSpeed: ButtonBorder!
    
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
        
        buttonPlay.frame = CGRect(x: Size.padding10..,
                                  y: Size.padding7..,
                                  width: Size.button..,
                                  height: Size.button..)
        
        buttonPlay.layer.cornerRadius = buttonPlay.frame.height / 2
        
        buttonSpeed.frame = CGRect(x: bounds.width - Size.padding10.. - Size.button..,
                                   y: Size.padding7.. ,
                                   width: Size.button..,
                                   height: Size.button..)
        
        buttonSpeed.layer.cornerRadius = buttonSpeed.frame.height / 2
        
        slider.frame = CGRect(x: buttonPlay.frame.maxX + Size.padding10.. / 2,
                              y: Size.padding7..,
                              width: buttonSpeed.frame.minX - buttonPlay.frame.maxX - Size.padding10..,
                              height: Size.button..)
        
        seperator.frame = CGRect(x: 0, y: 0, width: bounds.width, height: onePixel())
    }
}

extension TrackingControlFooterView {
    
    func buttonPlay(_ sender: UIButton) {
        
        switch playState {
        case .play:
            playState = .pause
        case .pause:
            playState = .play
        }
        
        
    }
    
    
    func buttonSpeed(_ sender: UIButton) {
        switch playSpeed {
        case .speed1X:
            playSpeed = .speed2X
            
        case .speed2X:
            playSpeed = .speed4X
            
        case .speed4X:
            playSpeed = .speed8X
            
        case .speed8X:
            playSpeed = .speed1X
        }
        
        buttonSpeed.setTitle("\(playSpeed..)x", for: UIControlState())
    }
    
    func sliderChangeValue(_ sender: UISlider) {
        
        guard sliderValue != Int(sender.value) else { return }
        sliderValue = Int(sender.value)
        delegate?.sliderValueChangedManually(sliderValue)
        
    }
    
    
    
    //    func rx_setup() {
    //
    //        rx_sliderCount.asObservable()
    //            .observeOn(MainScheduler.instance)
    //            .subscribeNext { [unowned self] in
    //                self.slider.minimumValue = 0
    //                self.slider.maximumValue = Float($0)
    //                self.rx_sliderValue.value = 0
    //            }
    //            .addDisposableTo(bag)
    //
    //        slider.rx_value
    //            .map { Int(floor($0)) }
    //            .bindTo(rx_sliderValueChangedManually)
    //            .addDisposableTo(bag)
    //
    //        rx_sliderValue
    //            .asObservable()
    //            .subscribeNext { [unowned self] in
    //                self.slider.setValue(Float($0), animated: true)
    //            }
    //            .addDisposableTo(bag)
    //
    //        buttonSpeed.rx_tap
    //            .asObservable()
    //            .map { [unowned self] in self.rx_playSpeed.value }
    //            .map { x -> PlaySpeed in
    //                switch x {
    //                case .Speed1X: return .Speed2X
    //                case .Speed2X: return .Speed4X
    //                case .Speed4X: return .Speed8X
    //                case .Speed8X: return .Speed1X
    //                }
    //            }
    //            .subscribeNext { [unowned self] in
    //                self.rx_playSpeed.value = $0
    //                self.buttonSpeed.setTitle("\($0.rawValue)x", forState: .Normal)
    //            }
    //            .addDisposableTo(bag)
    //
    //        buttonPlay.rx_tap
    //            .map { [unowned self] in self.rx_playState.value }
    //            .map { x -> PlayState in
    //                switch x {
    //                case .Play: return .Pause
    //                case .Pause: return .Play
    //                }
    //            }
    //            .bindTo(rx_playState)
    //            .addDisposableTo(bag)
    //
    //        rx_playState
    //            .asObservable()
    //            .map { $0.getImageForState() }
    //            .subscribeNext { [unowned self] in
    //                self.buttonPlay.setImage($0, forState: .Normal)
    //            }
    //            .addDisposableTo(bag)
    //    }
    
    func setup() {
        seperator = setupSeperator()
        buttonPlay = setupButtonPlay()
        slider = setupSlider()
        
        buttonSpeed = setupButton(
            UIColor.white,
            title: "\(playSpeed..)x",
            alignment: .center,
            font: UIFont(name: FontType.latoBold.., size: FontSize.large--)!)
        
        buttonSpeed.addTarget(self, action: #selector(self.buttonSpeed(_:)), for: .touchUpInside)
        
        
        addSubview(buttonPlay)
        addSubview(slider)
        addSubview(buttonSpeed)
        //        addSubview(seperator)
        
        layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3.0
        layer.shadowOffset = CGSize(width: 0.0, height: -1.5)
        
        backgroundColor = UIColor.main
    }
    
    fileprivate func setupButton(_ titleColor: UIColor = UIColor.main,
                                 title: String,
                                 alignment: UIControlContentHorizontalAlignment = .center,
                                 font: UIFont = UIFont(name: FontType.latoRegular.., size: FontSize.normal..)!) -> ButtonBorder {
        
        let button = ButtonBorder()
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(titleColor, for: UIControlState())
        button.titleLabel?.font = font
        button.contentHorizontalAlignment = alignment
        
        return button
    }
    
    fileprivate func setupSlider() -> UISlider {
        let slider = UISlider()
        slider.minimumTrackTintColor = UIColor.white
        slider.maximumValue = Float(sliderCount)
        slider.value = Float(sliderValue)
        slider.addTarget(self, action: #selector(self.sliderChangeValue(_:)), for: .valueChanged)
        return slider
    }
    
    fileprivate func setupButtonPlay() -> ButtonBorder {
        let button = ButtonBorder()
        button.setImage(playState.getImageForState(), for: UIControlState())
        button.addTarget(self, action: #selector(self.buttonPlay(_:)), for: .touchUpInside)
        button.contentMode = .scaleAspectFill
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }
    
    fileprivate func setupSeperator() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }
    
    
    func viewHeight() -> CGFloat {
        return Size.padding7.. + Size.button.. + Size.padding7..
    }
}


class ButtonBorder: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        var frame = rect
        frame.origin.x += 4
        frame.origin.y += 4
        frame.size.width -= 8
        frame.size.height -= 8
        
        let windows = UIBezierPath(roundedRect: frame, cornerRadius: frame.height / 2)
        
        windows.lineWidth = onePixel() * 2
        UIColor.white.setStroke()
        windows.stroke()
        
        super.draw(rect)
    }
}
