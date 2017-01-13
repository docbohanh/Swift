//
//  MapButton.swift
//  TrakingMe
//
//  Created by Thành Lã on 12/31/16.
//  Copyright © 2016 Bình Anh Electonics. All rights reserved.
//

import UIKit

class MapButton: MKButton {
    
    fileprivate enum Size: CGFloat {
        case button = 40
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        backgroundColor = UIColor(white: 1.0, alpha: 0.95)
        clipsToBounds = true
        layer.masksToBounds = false
        layer.shadowRadius = 1.5
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize( width: 0.0, height: 0.0)
        layer.shadowColor = UIColor.black.cgColor
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}

