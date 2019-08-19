//
//  AppDelegate.swift
//  VeganWay
//
//  Created by Oron Bernat on 29/11/2018.
//  Copyright © 2018 Bernat Investing. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        UITabBar.appearance().barTintColor = #colorLiteral(red: 0, green: 0.7490196078, blue: 1, alpha: 1)        
        return true
    }
}

