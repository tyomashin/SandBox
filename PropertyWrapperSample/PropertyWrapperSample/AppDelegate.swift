//
//  AppDelegate.swift
//  PropertyWrapperSample
//
//  Created by 岡崎伸也 on 2021/04/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        AppData.firstLaunchFlag = false
        print(AppData.firstLaunchFlag)
        
        AppData.sample = "aaa"
        print(AppData.sample)
        
        AppData.sampleEnum = .aaa
        print(AppData.sampleEnum)
        return true
    }

    // MARK: UISceneSession Lifecycle


}

