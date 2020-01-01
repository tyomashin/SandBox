//
//  AppDelegate.swift
//  GeofenceSample
//
//  Created by 岡崎伸也 on 2019/11/10.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let locationManager = LocationManager()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // リージョンの削除
        /*
        let locationManager = LocationManager()
        for region in locationManager.myLocationManager.monitoredRegions{
            locationManager.myLocationManager.stopMonitoring(for: region)
        }
        */
        print(locationManager.myLocationManager.monitoredRegions)
        
        // 位置情報が理由で起動した場合
        // memo: 位置情報で起動した場合でもここは空になってしまう=呼ばれない
        if let launchOptions = launchOptions{
            
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm"
            format.timeZone   = TimeZone(identifier: "Asia/Tokyo")
            
            let content = UNMutableNotificationContent()
            content.title = "launch app from location trigger"
            content.subtitle = "date : \(format.string(from: date)), \(launchOptions)"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "launchApp",
                                                content: content,
                                                trigger: trigger)
            
            // ローカル通知予約
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.add(request, withCompletionHandler: nil)
            
            UserDefaults.standard.set("location launch : \(format.string(from: date))", forKey: "LAUNCH_DATE")
            
            locationManager.getLocationManager(targetId: 1, delegate: nil)
            locationManager.myLocationManager.startUpdatingLocation()
            // 登録したエリアに対して現在の状態を問い合わせる
            // memo: didDetermineState が呼び出される想定
            for region in locationManager.myLocationManager.monitoredRegions{
                locationManager.myLocationManager.requestState(for: region)
            }
        }
        // 位置情報で起動した場合もこちらが呼ばれる.
        // 一度起動したらしばらく起動し続ける模様。= 起動通知は出ずに、didDetermineStateが呼ばれた通知が出たため。
        else{
            
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm"
            format.timeZone   = TimeZone(identifier: "Asia/Tokyo")
            
            let content = UNMutableNotificationContent()
            content.title = "launch app nomal"
            content.subtitle = "date : \(format.string(from: date))"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "launchApp",
                                                content: content,
                                                trigger: trigger)
            
            // ローカル通知予約
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.add(request, withCompletionHandler: nil)
            
            locationManager.getLocationManager(targetId: 1, delegate: nil)
            locationManager.myLocationManager.startUpdatingLocation()
            // 登録したエリアに対して現在の状態を問い合わせる
            // memo: didDetermineState が呼び出される想定
            for region in locationManager.myLocationManager.monitoredRegions{
                locationManager.myLocationManager.requestState(for: region)
            }
            
            // 通知許可ダイアログ
            if #available(iOS 10.0, *) {
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
                    if error != nil {
                        // エラー
                        return
                    }

                    if granted {
                        // 通知許可された
                    } else {
                        // 通知拒否
                    }
                }
            } else {
                //let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                //UIApplication.shared.registerUserNotificationSettings(settings)
            }
        }
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate : UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge,.sound])
    }
}

