//
//  HeaderTableView.swift
//  TrakingMe
//
//  Created by MILIKET on 1/8/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import UIKit
import PHExtensions

class HeaderTableView: UIView {
    
    enum Size: CGFloat {
        case Padding15 = 15, Padding10 = 10, Label = 16, Image = 20
    }
    
    var title: UILabel!
    var seperator: UIView!
    var arrow: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        
        arrow.frame = CGRect(x: bounds.width - Size.Image.. - Size.Padding10..,
                             y: (bounds.height - Size.Image.. ) / 2,
                             width: Size.Image..,
                             height: Size.Image..)
        
        title.frame = CGRect(x: (bounds.width - 200) / 2,
                             y: Size.Padding10..,
                             width: 200,
                             height: Size.Padding10.. * 2)
        
        
        seperator.frame = CGRect(x: 0, y: bounds.height - onePixel(), width: bounds.width, height: onePixel())
    }
    
    func setup() {
        
        title = setTitle()
        seperator = setupView()
        
        arrow = setupImageView(image: Icon.General.arrowDown.tint(UIColor.darkGray))
        
        
        addSubview(title)
//        addSubview(seperator)
        addSubview(arrow)
    }
    
    func setupImageView(image: UIImage) -> UIImageView {
        let bgImage = UIImageView(image: image)
        bgImage.contentMode = .scaleAspectFill
        return bgImage
    }
    
    func setTitle() -> UILabel {
        let textLabel = UILabel()
        textLabel.textAlignment = .center
        textLabel.font = UIFont(name: FontType.latoItalic.., size: FontSize.normal..)
        textLabel.textColor = UIColor.gray
        textLabel.numberOfLines = 2
        return textLabel
    }
    
    func setupView(bgColor: UIColor = UIColor.lightGray) -> UIView {
        let view = UIView()
        view.backgroundColor = bgColor
        return view
    }
}
