//
//  GeneralViewController.swift
//  BAMapTools
//
//  Created by IOS on 10/12/16.
//  Copyright © 2016 Binh Anh. All rights reserved.
//


import UIKit
import PHExtensions
import CleanroomLogger

class GeneralViewController: UIViewController {
    
    var didSetupConstraints: Bool = false
    var alertController: UIAlertController?
    var scrollHeight: CGFloat = 0
    
    var dateFormatterDefault: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    deinit {
        Log.message(.warning, message: "-------------------------------------------------")
        Log.message(.warning, message: "\t \t \(type(of: self)) DE-INIT")
        Log.message(.warning, message: "-------------------------------------------------")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Log.message(.warning, message: "-------------------------------------------------")
        Log.message(.warning, message: "\t \t \(type(of: self)) INIT")
        Log.message(.warning, message: "-------------------------------------------------")
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        Log.message(.warning, message: "-------------------------------------------------")
        Log.message(.warning, message: "\t \t \(type(of: self)) INIT")
        Log.message(.warning, message: "-------------------------------------------------")
    }
    
    
    /**
     Setup Bar Button
     */
    func setupBarButton(image: UIImage, selector: Selector, target: AnyObject? = nil) -> UIBarButtonItem {
        let button = UIBarButtonItem(image: image, style: .plain, target: target, action: selector)
        button.tintColor = UIColor.white
        return button
    }
    
    /**
     Setup Table
     */
    func setupTable<T>(dataSource: T, cellClass: AnyClass, emptyClass: AnyClass? = nil) -> UITableView
    where T: UITableViewDataSource, T: UITableViewDelegate {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(cellClass, forCellReuseIdentifier: "Cell")
        table.delegate = dataSource
        table.dataSource = dataSource
        table.isDirectionalLockEnabled = true
        table.separatorStyle = .none
        table.backgroundColor = .white
        return table
    }
}
