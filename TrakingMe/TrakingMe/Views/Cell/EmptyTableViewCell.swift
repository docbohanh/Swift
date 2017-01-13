//
//  EmptyTableViewCell.swift
//  TrakingMe
//
//  Created by Thành Lã on 12/30/16.
//  Copyright © 2016 Bình Anh Electonics. All rights reserved.
//


import UIKit
import PHExtensions

class EmptyTableViewCell: UITableViewCell {
    
    private enum Size: CGFloat {
        case padding15 = 15, image = 70, label = 60
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabel()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
    }
    
    func setupLabel() {
        textLabel?.font = UIFont(name: FontType.latoRegular.., size: FontSize.normal++)
        textLabel?.numberOfLines = 0
        textLabel?.lineBreakMode = .byWordWrapping
        textLabel?.textAlignment = .center
        textLabel?.textColor = UIColor.darkGray
        
        imageView?.contentMode = .scaleAspectFit
        
        backgroundColor =  UIColor.groupTableViewBackground
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        guard let imageView = imageView else {
            textLabel?.frame.origin.y -= 50
            return
        }
        
        imageView.frame = CGRect(x: (bounds.width - Size.image.. ) / 2,
                                 y: bounds.height / 3 - Size.image.. - Size.padding15.. * 2,
                                 width: Size.image..,
                                 height: Size.image..)
        
        textLabel?.frame = CGRect(x: Size.padding15..,
                                  y: imageView.frame.maxY,
                                  width: bounds.width - Size.padding15.. * 2,
                                  height: Size.label..)
    }
}
