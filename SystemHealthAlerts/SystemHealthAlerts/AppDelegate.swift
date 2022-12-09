//
//  AppDelegate.swift
//  SystemHealthAlerts
//
//  Created by Santanu Karar on 31/08/20.
//  Copyright © 2020 Santanu Karar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication)
    {
        ReloadTimer.getInstance.pauseRefreshCountTimer()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication)
    {
        DispatchQueue.main.async {
            ReloadTimer.getInstance.restartPausedCounter()
            if (ConstantsVO.reloadInEvent.self.rawValue != 0), (ReloadTimer.getInstance.pausedSeconds != 0), let cachedAlertItemsController = ConstantsVO.alertItemsView.object(forKey: "alertItemsTableViewController")
            {
                cachedAlertItemsController.dataUpdateFailed(error: "The system turned into sleep mode!\nHang on! I'm trying to reload fresh data in a moment.")
            }
        }
    }
}

