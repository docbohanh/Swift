//
//  AppDelegate.swift
//  TrakingMe
//
//  Created by Thành Lã on 12/30/16.
//  Copyright © 2016 Bình Anh Electonics. All rights reserved.
//

import UIKit
import GoogleMaps
import CleanroomLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FileManager.default.createAppDirectory("Log", skipBackupAttribute: true)
        let path = FileManager.default.getDocumentDirectory().appendingPathComponent("Log")
        Log.enable(configuration: CustomLogConfiguration(minimumSeverity: .verbose, dayToKeep: 60, filePath: path.path))
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let GMSServiceKey = "AIzaSyDGP7n2-4MKQjQ6ucNROKPDrjvWLM5etfo"
        GMSServices.provideAPIKey(GMSServiceKey)
        
        let trackingsVC = TrackingListsViewController()
        let navigationController = setupNavigationController(withRoot: trackingsVC)
        
        if let window = window {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.        
        NotificationCenter.default.post(name: Notification.Name(AppNotification.SaveTrackingSignal.rawValue), object: nil)
    }


    /**
     Setup Navigation
     */
    fileprivate func setupNavigationController(withRoot viewController: UIViewController) -> UINavigationController {
        
        let navigationController = UINavigationController(rootViewController: viewController)
        Utility.shared.configureAppearance(navigation: navigationController)
        
        return navigationController
    }

}

