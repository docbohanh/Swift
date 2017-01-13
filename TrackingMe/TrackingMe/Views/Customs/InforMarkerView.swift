//
//  InforMarkerView.swift
//  Dang
//
//  Created by Thành Lã on 12/30/16.
//  Copyright © 2016 IOS. All rights reserved.
//

import UIKit
import PHExtensions

class InforMarkerView: UIView {
    
    fileprivate enum Size: CGFloat {
        case label = 18, padding5 = 5, image = 44, padding10 = 10, padding15 = 15
    }
    
    var title: UILabel!
    var descriptions: UILabel!
    
    var background: CenterView = {
        return CenterView()
    }()
    
    var avatar: Avatar = {
        return Avatar()
    }()
    
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        backgroundColor = UIColor.clear
        
        title = setupLabel(color: .darkGray, font: UIFont(name: FontType.latoSemibold.., size: 14)!)
        descriptions = setupLabel(color: .lightGray, font: UIFont(name: FontType.latoRegular.., size: 13)!)
        
        addSubview(background)
        addSubview(avatar)
        addSubview(title)
        addSubview(descriptions)
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        background.frame = CGRect(x: 0,
                                  y: Size.image.. / 2,
                                  width: bounds.width,
                                  height: bounds.height - Size.image.. / 2)
        
        avatar.frame = CGRect(x: (bounds.width) / 2 - Size.padding5..,
                              y: 0,
                              width: Size.image..,
                              height: Size.image..)
        avatar.layer.cornerRadius = avatar.frame.height / 2
        
        descriptions.frame = CGRect(x: Size.padding5..,
                                    y: bounds.height - Size.label.. - Size.padding10..,
                                    width: bounds.width - Size.padding5.. * 2,
                                    height: Size.label..)
        
        title.frame = CGRect(x: Size.padding5..,
                             y: descriptions.frame.minY - Size.label..,
                             width: bounds.width - Size.padding5.. * 2,
                             height: Size.label..)
        
        
    }
    
    fileprivate func setupView() -> CenterView {
        let view = CenterView()
        return view
    }
    
    fileprivate func setupLabel(color: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textAlignment = .center
        label.contentMode = .center
        label.textColor = color
        label.clipsToBounds = true
        return label
    }
    
    fileprivate func setupAvatar() -> Avatar {
        let avatar = Avatar()
        
        return avatar
    }
    
}
