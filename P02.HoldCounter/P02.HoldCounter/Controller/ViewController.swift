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
    fileprivate var timer: Timer!

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


//MARK: PRIVATE METHOD
extension ViewController {
    func reset(_ sender: UIBarButtonItem) {
        counter.text = "0"
    }
    
    func countMe() {
        if let number = counter.text, let count = Int(number) {
            counter.text = String(count + 1)
        }
    }
    
    
    func holdMe(_ sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.countMe), userInfo: nil, repeats: true)
    }
    
    func letMeOut(_ sender: UIButton) {
        timer.invalidate()
    }
    
}

//MARK: SETUP VIEW
extension ViewController {
    fileprivate func setupAllSubViews() {
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        title = "Counter"
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.main,
                                                                   NSFontAttributeName : UIFont(name: FontType.latoRegular..,
                                                                                                size: FontSize.normal.. + 3)!]
        
        counter = setupLabel()
        tapButton = setupButton(title: "Tap or Hold")
        tapButton.addTarget(self, action: #selector(self.holdMe(_:)), for: .touchDown)
        tapButton.addTarget(self, action: #selector(self.letMeOut(_:)), for: [.touchUpOutside, .touchUpInside])
        
        setupBarButton()
        
        view.addSubview(counter)
        view.addSubview(tapButton)
        
    }
    
    fileprivate func setupAllConstraints() {
        
        counter.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(200)
            make.bottom.equalTo(view.snp.bottom).inset(view.frame.height / 2)
        }
        
        tapButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.top.equalTo(counter.snp.bottom).offset(-15)
        }
        
    }
    
    fileprivate func setupLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: FontType.latoLight.., size: 90)
        label.textColor = UIColor.Segment.lightBlue
        label.textAlignment = .center
        label.text = "0"
        return label
    }
    
    fileprivate func setupButton(title: String) -> UIButton {
        let button = UIButton()
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

