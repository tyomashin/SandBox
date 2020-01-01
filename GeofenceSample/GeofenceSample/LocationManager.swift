//
//  LocationManager.swift
//  GeofenceSample
//
//  Created by 岡崎伸也 on 2019/11/10.
//  Copyright © 2019 sample. All rights reserved.
//

import Foundation
import CoreLocation
import UserNotifications

protocol LocationManagerDelegate {
    func updateLocation(lat : CLLocationDegrees, lng : CLLocationDegrees)
}

class LocationManager : NSObject{
    
    // 位置情報の取得タイミングに関するタイプ
    /*
    enum MyAuthorizationType{
        case Always
        case WhenInUse
    }
    */
    
    var myLocationManager : CLLocationManager = CLLocationManager()
    var targetId : Int = 0
    var locationManagerDelegate : LocationManagerDelegate? = nil
    
    // ロケーションマネージャインスタンスを取得する
    func getLocationManager(targetId : Int, delegate : LocationManagerDelegate?) -> CLLocationManager{
        
        self.targetId = targetId
        self.locationManagerDelegate = delegate
        myLocationManager.delegate = self
        myLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        // 位置情報利用の承認状況
        // https://developer.apple.com/documentation/corelocation/clauthorizationstatus
        let status = CLLocationManager.authorizationStatus()
        myLocationManager.requestAlwaysAuthorization()
        // まだユーザが位置情報利用許可を選択していない時
        if status == .notDetermined{
            // バックグラウンドでも許可を取る
            //myLocationManager.requestAlwaysAuthorization()
            /*
            if myAuthorizationType == .Always{
                // バックグラウンドでも許可を取る
                myLocationManager.requestAlwaysAuthorization()
            }
            else if myAuthorizationType == .WhenInUse{
                myLocationManager.requestWhenInUseAuthorization()
            }
            */
        }
        return myLocationManager
    }
    // ローカル通知を発行
    // 参考：https://qiita.com/mshrwtnb/items/3135e931eedc97479bb5#%E4%BE%8B%E4%B8%80%E5%BA%A6%E3%81%A0%E3%81%91%E9%80%9A%E7%9F%A5
    func createNotification(region : CLRegion?, _ title : String? = nil){
        let content = UNMutableNotificationContent()
        if title == nil{
            content.title = "enter region"
        }else{
            content.title = title!
        }
        content.subtitle = "id : \(region?.identifier ?? "nil")"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "inner",
                                            content: content,
                                            trigger: trigger)
        // ローカル通知予約
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.add(request, withCompletionHandler: nil)
    }
    
}

extension LocationManager : UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge,.sound])
    }
}

// 参考：https://sites.google.com/a/gclue.jp/swift-docs/ni-yinki100-ios/06-corelocation/004-ibeaconno-jian-chu
extension LocationManager : CLLocationManagerDelegate{
    // 位置情報取得時
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location{
            print("対象ID：\(targetId)")
            print("緯度経度：(\(location.coordinate.latitude), \(location.coordinate.longitude)")
            // 通知先に緯度経度を送信する
            locationManagerDelegate?.updateLocation(lat: location.coordinate.latitude,
                                                    lng: location.coordinate.longitude)
        }
    }
    // モニタリング開始の通知を受けとる
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("monitaring start : \(region.identifier)")
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        format.timeZone   = TimeZone(identifier: "Asia/Tokyo")
        
        UserDefaults.standard.set("\(format.string(from: date))", forKey: "MONITARING_START")
        
        // この時点でビーコンがすでにRegion内に入っている可能性があるので、その問い合わせを行う
        // (Delegate didDetermineStateが呼ばれる)
        //myLocationManager.requestState(for: region)
    }
    
    // 現在リージョン内にいるかどうかの通知を受け取る
    func locationManager(_ manager: CLLocationManager,
                         didDetermineState state: CLRegionState,
                         for region: CLRegion) {
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        format.timeZone   = TimeZone(identifier: "Asia/Tokyo")
        
        switch state {
        case .inside:
            print("\(region.identifier) : inside")
            createNotification(region: region, "すでに入っていた")
            UserDefaults.standard.set("in : \(format.string(from: date))", forKey: "CHECKIN")
        case .outside:
            print("\(region.identifier) : outside")
            createNotification(region: region, "外に出た")
            UserDefaults.standard.set("out : \(format.string(from: date))", forKey: "CHECKOUT")
        default:
            break
        }
    }
    
    // ジオフェンス領域に入ったことを検知
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        format.timeZone   = TimeZone(identifier: "Asia/Tokyo")
        
        if region is CLCircularRegion{
            //UserDefaults.standard.set("in : \(format.string(from: date))", forKey: "checkin")
            if region.identifier == "1"{
                createNotification(region: region)
                UserDefaults.standard.set("\(format.string(from: date))", forKey: "GEOFENCE_IN_DATE_1")
                UserDefaults.standard.set("\(region.identifier)", forKey: "GEOFENCE_REGION_ID_1")
            }
            if region.identifier == "famima"{
                createNotification(region: region)
                UserDefaults.standard.set("\(format.string(from: date))", forKey: "GEOFENCE_IN_DATE_FAMIMA")
                UserDefaults.standard.set("\(region.identifier)", forKey: "GEOFENCE_REGION_ID_FAMIMA")
            }
            if region.identifier == "motomachi"{
                createNotification(region: region)
            }
            // 領域監視を終了
            //myLocationManager.stopMonitoring(for: region)
        }
    }
    // ジオフェンスから出たことを通知
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        format.timeZone   = TimeZone(identifier: "Asia/Tokyo")
        
        if region is CLCircularRegion{
            //UserDefaults.standard.set("out : \(format.string(from: date))", forKey: "checkout")
            if region.identifier == "1"{
                createNotification(region: region, "リージョンから出た")
                UserDefaults.standard.set("\(format.string(from: date))", forKey: "GEOFENCE_IN_DATE_1")
                UserDefaults.standard.set("\(region.identifier)", forKey: "GEOFENCE_REGION_ID_1")
            }
            if region.identifier == "famima"{
                createNotification(region: region, "リージョンから出た")
                UserDefaults.standard.set("\(format.string(from: date))", forKey: "GEOFENCE_IN_DATE_FAMIMA")
                UserDefaults.standard.set("\(region.identifier)", forKey: "GEOFENCE_REGION_ID_FAMIMA")
            }
            if region.identifier == "motomachi"{
                createNotification(region: region, "リージョンから出た")
            }
            // 領域監視を終了
            //myLocationManager.stopMonitoring(for: region)
        }
    }
    
}
