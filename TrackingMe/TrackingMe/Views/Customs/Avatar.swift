//
//  Avatar.swift
//  Dang
//
//  Created by Thành Lã on 12/30/16.
//  Copyright © 2016 IOS. All rights reserved.
//

import UIKit
import PHExtensions

class Avatar: UIView {
    
    fileprivate enum Size: CGFloat {
        case image = 44, padding = 3
    }
    
    var title: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontType.latoRegular.., size: FontSize.normal..)
        label.textAlignment = .center
        label.contentMode = .center
        label.textColor = UIColor.darkGray
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        return label
    }()
    
    var viewImageShadow: UIView!
    var avatarImage: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        
        viewImageShadow = setupViewShadow()
        addSubview(viewImageShadow)
        
        avatarImage = setupAvatar()
        viewImageShadow.addSubview(avatarImage)
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewImageShadow.frame = CGRect(x: (bounds.width / 4 - Size.image..) / 2,
                                       y: (bounds.height - Size.image..) / 2,
                                       width: Size.image..,
                                       height: Size.image..)
        viewImageShadow.layer.cornerRadius = viewImageShadow.frame.height / 2
        
        avatarImage.frame = CGRect(x: Size.padding..,
                                   y: Size.padding..,
                                   width: Size.image.. - Size.padding.. * 2,
                                   height: Size.image.. - Size.padding.. * 2)
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
    }
    
    fileprivate func setupViewShadow() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        return view
    }
    
    fileprivate func setupAvatar() -> UIImageView  {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = false
//        imageView.layer.shadowRadius = 2.0
//        imageView.layer.shadowOpacity = 0.3
//        imageView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        imageView.layer.shadowColor = UIColor.black.alpha(0.4).cgColor
        imageView.layer.borderColor = UIColor.lightGray.alpha(0.4).cgColor
        imageView.layer.borderWidth = 1 / UIScreen.main.scale
        return imageView
    }

    
}
