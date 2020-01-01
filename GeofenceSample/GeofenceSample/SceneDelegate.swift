//
//  SceneDelegate.swift
//  GeofenceSample
//
//  Created by 岡崎伸也 on 2019/11/10.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let locationManager = LocationManager()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
        // ジオフェンスを登録する
        
        //locationManager.getLocationManager(targetId: 3, delegate: nil)
        
        let coordinate1 = CLLocationCoordinate2DMake(34.735492, 135.411109)
        let region1 = CLCircularRegion(center: coordinate1, radius: 200, identifier: "1")
        locationManager.myLocationManager.startMonitoring(for: region1)
        
        let coordinate2 = CLLocationCoordinate2DMake(34.741143, 135.405345)
        let region2 = CLCircularRegion(center: coordinate2, radius: 200, identifier: "famima")
        locationManager.myLocationManager.startMonitoring(for: region2)
        
        let coordinate3 = CLLocationCoordinate2DMake(34.689782, 135.187254)
        let region3 = CLCircularRegion(center: coordinate3, radius: 5000, identifier: "motomachi")
        locationManager.myLocationManager.startMonitoring(for: region3)
        
        // 位置情報が500m以上移動したら再起動するようにしている
        // https://stackoverflow.com/questions/44369117/receiving-location-even-when-app-is-not-running-in-swift
        locationManager.myLocationManager.startMonitoringSignificantLocationChanges()
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        format.timeZone   = TimeZone(identifier: "Asia/Tokyo")
        
        UserDefaults.standard.set("app finish : \(format.string(from: date))", forKey: "FINISH_DATE")
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        locationManager.getLocationManager(targetId: 0, delegate: nil).startUpdatingLocation()
        locationManager.myLocationManager.allowsBackgroundLocationUpdates = true
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        print("enter background")
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        format.timeZone   = TimeZone(identifier: "Asia/Tokyo")
        
        UserDefaults.standard.set("app background : \(format.string(from: date))", forKey: "FINISH_DATE")
        
        // バックグラウンド取得を許可
        //myLocationManager.allowsBackgroundLocationUpdates = true
    }


}

