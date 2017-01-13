//
//  CenterView.swift
//  Dang
//
//  Created by Thành Lã on 12/30/16.
//  Copyright © 2016 IOS. All rights reserved.
//

import UIKit

class CenterView: UIView {
    
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
        layer.masksToBounds = false
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowColor = UIColor.black.alpha(0.7).cgColor
        
    }
        
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        var frame = rect
        frame.origin.x += 1
        frame.origin.y += 1
        frame.size.width -= 2
        frame.size.height -= 6
        
        let windows = UIBezierPath(roundedRect: frame, cornerRadius:  3 )
        
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x: frame.midX - 10 / 2, y: frame.height + 1))
        arrowPath.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        arrowPath.addLine(to: CGPoint(x: frame.midX + 10 / 2, y: frame.height + 1))
        windows.append(arrowPath)
        
        UIColor.white.setFill()
        windows.fill()
    }
    
}
