//
//  ViewController.swift
//  P01.TapCounter
//
//  Created by MILIKET on 12/28/16.
//  Copyright © 2016 Bình Anh Electonics. All rights reserved.
//

import UIKit
import SnapKit
import PHExtensions

class ViewController: UIViewController {
    
    fileprivate var didSetupConstraints: Bool = false
    
    fileprivate var counter: UILabel!
    fileprivate var tapButton: UIButton!

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
        
        UIApplication.shared.statusBarStyle = .default
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isTranslucent = false
        title = "Tap Counter"
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.main,
                                                                   NSFontAttributeName : UIFont(name: FontType.latoRegular.., size: FontSize.normal++)!]
        
        counter = setupLabel()
        tapButton = setupButton(title: "Tap Me")
        
        setupBarButton()
        
        view.addSubview(counter)
        view.addSubview(tapButton)
        
    }
    
    fileprivate func setupAllConstraints() {
        
        counter.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.equalTo(100)
            make.height.equalTo(200)
        }
        
        tapButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.equalTo(counter.snp.width)
            make.height.equalTo(50)
            make.top.equalTo(counter.snp.bottom).offset(-15)
        }
        
    }
    
    fileprivate func setupLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: FontType.latoBold.., size: FontSize.large..)
        return label
    }
    
    fileprivate func setupButton(title: String) -> UIButton {
        let button = MKButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: FontType.latoSemibold.., size: FontSize.large++)
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
    func reset(_ sender: UIBarButtonItem) {
        
    }
}
