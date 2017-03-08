//
//  ViewController.swift
//  P01.TapCounter
//
//  Created by MILIKET on 12/28/16.
//  Copyright © 2016 Bình Anh Electonics. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    fileprivate var didSetupConstraints: Bool = false
    
    fileprivate var counter: UILabel!
    fileprivate var tapButton: UIButton!
    fileprivate var loginFb: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAllSubViews()
        view.setNeedsUpdateConstraints()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func updateViewConstraints() {
        guard !didSetupConstraints else {
            super.updateViewConstraints()
            return
        }
        
        setupAllConstraints()
        super.updateViewConstraints()
        didSetupConstraints = true
    }

}

//MARK: SETUP VIEW
extension ViewController {
    fileprivate func setupAllSubViews() {
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        title = "Tap Counter"
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.main,
                                                                   NSFontAttributeName : UIFont(name: FontType.latoRegular.rawValue,
                                                                                                size: FontSize.normal.. + 1)!]
        
        counter = setupLabel()
        tapButton = setupButton(title: "Tap Me")
        tapButton.addTarget(self, action: #selector(self.tapMe(_:)), for: .touchUpInside)
        
        setupBarButton()
        loginFb = setupButton()
        
        view.addSubview(counter)
        view.addSubview(tapButton)
        view.addSubview(loginFb)
    }
    
    fileprivate func setupAllConstraints() {
        
        counter.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.bottom.equalTo(view.snp.bottom).inset(view.frame.height / 2)
        }
        
        tapButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.equalTo(counter.snp.width)
            make.height.equalTo(50)
            make.top.equalTo(counter.snp.bottom).offset(-15)
        }
        
        loginFb.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.top.equalTo(tapButton.snp.bottom).offset(-15)
        }
        
    }
    
    func setupButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(self.login(_:)), for: .touchUpInside)
        return button
    }
    
    fileprivate func setupLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: FontType.latoSemibold.., size: 90)
        label.textColor = UIColor.orange
        label.textAlignment = .center
        label.text = "0"
        return label
    }
    
    fileprivate func setupButton(title: String) -> UIButton {
        let button = MKButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: FontType.latoSemibold.., size: FontSize.large.. + 1)
        button.setTitleColor(UIColor.main, for: .normal)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1 / UIScreen.main.scale
        button.layer.borderColor = UIColor.main.cgColor
        return button
    }
    
    fileprivate func setupBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(self.reset(_:)))
    }
    
}

//MARK: PRIVATE METHOD
extension ViewController {
    func login(_ sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    
    func reset(_ sender: UIBarButtonItem) {
        counter.text = "0"
    }
    
    func tapMe(_ sender: UIButton) {
        if let number = counter.text, let count = Int(number) {
            counter.text = String(count + 1)
        }
    }
}
