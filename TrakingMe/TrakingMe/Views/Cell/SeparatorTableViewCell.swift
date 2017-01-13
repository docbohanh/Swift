//
//  SeparatorTableViewCell.swift
//  TrakingMe
//
//  Created by Thành Lã on 12/30/16.
//  Copyright © 2016 Bình Anh Electonics. All rights reserved.
//

import UIKit
import PHExtensions
import Eureka

class SeparatorTableViewCell: UITableViewCell {
    
    enum SeperatorStyle {
        case hidden
        case padding(CGFloat)
    }
    var seperatorStyle: SeperatorStyle = .padding(15) {
        didSet {
            switch seperatorStyle {
            case .hidden:
                seperator.isHidden = true
            case .padding(_):
                seperator.isHidden = false
            }
        }
    }
    
    var seperatorRightPadding: CGFloat = 15
    
    var seperator: UIView! = {
        var view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        contentView.insertSubview(seperator, aboveSubview: textLabel!)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.insertSubview(seperator, aboveSubview: textLabel!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView!.frame = CGRect(x: 15, y: (bounds.height - 22) / 2, width: 22, height: 22)
        imageView!.contentMode = .center
        
        let padding = imageView?.frame.maxX ?? 0
        
        textLabel!.frame = CGRect(x: 15 + padding, y: (bounds.height - 22) / 2, width: bounds.width / 2, height: 22)
        textLabel!.contentMode = .center
        
        
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
