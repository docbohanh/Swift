//
//  TrackingTableViewCell.swift
//  TrakingMe
//
//  Created by Thành Lã on 12/31/16.
//  Copyright © 2016 Bình Anh Electonics. All rights reserved.
//

import UIKit
import PHExtensions

class TrackingTableViewCell: SeparatorTableViewCell {
    
    fileprivate enum Size: CGFloat {
        case padding5 = 5, padding10 = 10, padding15 = 15, button = 44, image = 40, cellHeight = 60
    }
    
    var textField: UITextField!
    var time: UILabel!
    
    fileprivate var dateTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss\ndd/MM/yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 7)
        return formatter
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = Utility.shared.widthForView(text: dateTimeFormatter.string(from: Date()),
                                                font: UIFont(name: FontType.latoRegular.., size: FontSize.small++)!,
                                                height: bounds.height)
        
        textField.frame = CGRect(x: imageView!.frame.maxX, // + Size.padding10..,
                                 y: (bounds.height - Size.button..) / 2,
                                 width: bounds.width - imageView!.frame.maxX - width - Size.padding15.. * 2,
                                 height: Size.button..)
        
        
        time.frame = CGRect(x: bounds.width - width - Size.padding15.. * 2,
                            y: 0,
                            width: width,
                            height: bounds.height)
        
        textLabel?.frame.origin.x = 15
        
        switch seperatorStyle {
        case .hidden:
            break
        case .padding(let padding):
            seperator.frame = CGRect(
                x: padding,
                y: contentView.bounds.height - onePixel(),
                width: UIScreen.main.bounds.width - padding - seperatorRightPadding,
                height: onePixel())
        }
    }
}


extension TrackingTableViewCell {
    
    fileprivate func setup() {
        
        seperator = setupSeperator()
        time = setupLabel(font: UIFont(name: FontType.latoRegular.., size: FontSize.normal--)!)
        textField = setupTextField()
        
        contentView.addSubview(textField)
        contentView.addSubview(time)
        
        contentView.insertSubview(seperator, aboveSubview: textLabel!)
        
    }
    
    fileprivate func setupTextField() -> UITextField {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.font = UIFont(name: FontType.latoSemibold.., size: FontSize.normal..)
        textField.textColor = UIColor.darkGray
        textField.autocorrectionType = .no
        textField.autoresizingMask = UIViewAutoresizing()
        textField.autocapitalizationType = .sentences
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        
        return textField
    }
    
    func setupLabel(textColor: UIColor = UIColor.darkText, font: UIFont, alignment: NSTextAlignment = .center) -> UILabel {
        let label = UILabel()
        label.textColor = textColor
        label.font = font
        label.textAlignment = alignment
        label.numberOfLines = 2
        return label
    }
    
    fileprivate func setupSeperator() -> UIView {
        let seperator = UIView()
        seperator.backgroundColor = UIColor.lightGray
        return seperator
    }
   
}

