//
//  AppDelegate.swift
//  Assignment
//
//  Created by Adeel-dev on 3/1/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: ApplicationFlowCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window =  UIWindow(frame: UIScreen.main.bounds)
        self.appCoordinator = ApplicationFlowCoordinator(window: window, dependencyProvider: ApplicationComponentsProvider())
        self.appCoordinator.start()

        self.window = window
        self.window?.makeKeyAndVisible()
        return true
    }
}

