//
//  MKTableViewCell.swift
//  MaterialKit
//
//  Created by Le Van Nghia on 11/15/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit
import PHExtensions

open class MKTableViewCell : UITableViewCell {
    
    fileprivate enum Size: CGFloat {
        case padding = 20, padding15 = 15
    }
    
    @IBInspectable open var maskEnabled: Bool = true {
        didSet {
            mkLayer.maskEnabled = maskEnabled
        }
    }
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            mkLayer.superLayerDidResize()
        }
    }
    @IBInspectable open var elevation: CGFloat = 0 {
        didSet {
            mkLayer.elevation = elevation
        }
    }
    @IBInspectable open var shadowOffset: CGSize = CGSize.zero {
        didSet {
            mkLayer.shadowOffset = shadowOffset
        }
    }
    @IBInspectable open var roundingCorners: UIRectCorner = UIRectCorner.allCorners {
        didSet {
            mkLayer.roundingCorners = roundingCorners
        }
    }
    @IBInspectable open var rippleEnabled: Bool = true {
        didSet {
            mkLayer.rippleEnabled = rippleEnabled
        }
    }
    @IBInspectable open var rippleDuration: CFTimeInterval = 0.35 {
        didSet {
            mkLayer.rippleDuration = rippleDuration
        }
    }
    @IBInspectable open var rippleScaleRatio: CGFloat = 1.0 {
        didSet {
            mkLayer.rippleScaleRatio = rippleScaleRatio
        }
    }
    @IBInspectable open var rippleLayerColor: UIColor = UIColor(hex: 0xEEEEEE) {
        didSet {
            mkLayer.setRippleColor(rippleLayerColor)
        }
    }
    @IBInspectable open var backgroundAnimationEnabled: Bool = true {
        didSet {
            mkLayer.backgroundAnimationEnabled = backgroundAnimationEnabled
        }
    }

    fileprivate lazy var mkLayer: MKLayer = MKLayer(withView: self.contentView)

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setup()
        setupLayer()
    }

    // MARK: Setup
    fileprivate func setupLayer() {
        selectionStyle = .none
        mkLayer.elevation = self.elevation
        self.layer.cornerRadius = self.cornerRadius
        mkLayer.elevationOffset = self.shadowOffset
        mkLayer.roundingCorners = self.roundingCorners
        mkLayer.maskEnabled = self.maskEnabled
        mkLayer.rippleScaleRatio = self.rippleScaleRatio
        mkLayer.rippleDuration = self.rippleDuration
        mkLayer.rippleEnabled = self.rippleEnabled
        mkLayer.backgroundAnimationEnabled = self.backgroundAnimationEnabled
        mkLayer.setRippleColor(self.rippleLayerColor)
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        mkLayer.touchesBegan(touches, withEvent: event)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        mkLayer.touchesEnded(touches, withEvent: event)
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        mkLayer.touchesCancelled(touches, withEvent: event)
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        mkLayer.touchesMoved(touches, withEvent: event)
    }
    
    
    
    fileprivate func setup() {
        backgroundColor = UIColor.clear
        textLabel?.font = UIFont(name: FontType.latoRegular.., size: FontSize.normal.rawValue + 1)
        textLabel?.textColor = UIColor.lightGray
        
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = CGRect(x: Size.padding15.., y: 0, width: bounds.width - Size.padding15.., height: bounds.height)
        
        imageView?.frame = CGRect(x: Size.padding..,
                                  y: imageView!.frame.origin.y,
                                  width: imageView!.frame.size.width,
                                  height: imageView!.frame.size.height)
        
        textLabel?.frame.origin.x = ceil(imageView!.frame.maxX + Size.padding..)
        textLabel?.frame.size.width = ceil(bounds.width * 3 / 4 - Size.padding.. - imageView!.frame.maxX - Size.padding..)
        
        detailTextLabel?.frame.origin.x = ceil(imageView!.frame.maxX + Size.padding..)
        detailTextLabel?.frame.size.width = ceil(bounds.width * 3 / 4  - Size.padding.. - imageView!.frame.maxX - Size.padding..)
        
    }
    
}
