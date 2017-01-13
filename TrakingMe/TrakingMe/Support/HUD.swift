//
//  File.swift
//  Staxi
//
//  Created by Hoan Pham on 7/20/15.
//  Copyright (c) 2015 Hoan Pham. All rights reserved.
//

import UIKit
import JGProgressHUD
import PHExtensions

class HUD {
    
    enum HUDType {
        case none
        case error, success
        case pie, ring
        case indeterminate
    }
    
    fileprivate enum LastHUD {
        case none
        case hud
        case message
    }
    
    static var style: JGProgressHUDStyle = .dark
    fileprivate static var hud: JGProgressHUD = JGProgressHUD(style: style)
    fileprivate static var lastest: LastHUD = .none
    
    fileprivate static func createIndicatorView(_ type: HUDType) -> JGProgressHUDIndicatorView {
        switch type {
        case .none:
            return JGProgressHUDIndicatorView()
        case .error:
            return JGProgressHUDErrorIndicatorView()
        case .success:
            return JGProgressHUDSuccessIndicatorView()
        case .pie:
            return JGProgressHUDPieIndicatorView(hudStyle: style)
        case .ring:
            return JGProgressHUDRingIndicatorView(hudStyle: style)
        case .indeterminate:
            return JGProgressHUDIndeterminateIndicatorView(hudStyle: style)
        }
    }
    
    static func showMessage(_ text: String, type: HUDType = .none, onView view: UIView? = nil, duration: TimeInterval = 3.second, position: JGProgressHUDPosition = .center, disableUserInteraction: Bool = false, insets: UIEdgeInsets? = nil, completion: (() -> Void)? = nil) {
        if JGProgressHUD.allProgressHUDs(in: view).count > 0 && lastest == .message { return }
        switch type {
        case .none:
            hud.indicatorView = nil
        default:
            hud.indicatorView = createIndicatorView(type)
        }
        hud.textLabel.text = text
        
        hud.textLabel.font = UIFont.systemFont(ofSize: 14)
        
        hud.minimumDisplayTime = 0.3.second
        hud.position = position
        hud.interactionType = disableUserInteraction ? .blockAllTouches : .blockNoTouches
        hud.contentInsets = UIEdgeInsets(top: 10, left: 15, bottom: 15, right: 15)
        
        var paddingBottom: CGFloat
        switch Device.size() {
        case .screen3_5Inch, .screen4Inch:
            paddingBottom = 150
        default:
            paddingBottom = 180
        }
        
        hud.marginInsets = insets ?? UIEdgeInsets(top: 5, left: 5, bottom: paddingBottom, right: 5)
        if let view = view {
            hud.show(in: view)
        } else {
            hud.show(in: UIApplication.shared.keyWindow?.rootViewController?.view)
        }
        hud.dismiss(afterDelay: duration)
        lastest = .message
        
        Timer.after(duration) { _ in
            HUD.lastest = .none
            if let completion = completion { completion() }
        }
    }
    
    static func showHUD(_ text: String? = nil, onView view: UIView? = nil, type: HUDType = .indeterminate, disableUserInteraction: Bool = true, position: JGProgressHUDPosition = .center, delay: TimeInterval = 0.5.second, action: (() -> Void)? = nil) {
        if JGProgressHUD.allProgressHUDs(in: view).count > 0 && lastest == .hud { return }
        
        switch type {
        case .none:
            hud.indicatorView = nil
        default:
            hud.indicatorView = createIndicatorView(type)
        }
        if let text = text , text.characters.count > 0 { hud.textLabel.text = text } else { hud.textLabel.text = nil }
        hud.textLabel.font = UIFont.systemFont(ofSize: 14)
        hud.minimumDisplayTime = 0.3.second
        hud.interactionType = .blockAllTouches
        hud.position = position
        hud.interactionType = disableUserInteraction ? .blockAllTouches : .blockNoTouches
        
        if let view = view {
            hud.show(in: view)
        } else {
            hud.show(in: UIApplication.shared.keyWindow?.rootViewController?.view)
        }
        
        Timer.after(delay) { _ in
            HUD.lastest = .none
            if let action = action { action() }
        }
        
    }
    
    static func dismissHUD(animated: Bool = true, completion:(() -> Void)? = nil) {
        hud.dismiss(animated: animated)
        if let completion = completion { completion() }
    }
}
