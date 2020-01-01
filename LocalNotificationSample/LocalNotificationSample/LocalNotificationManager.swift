//
//  LocalNotificationManager.swift
//  LocalNotificationSample
//
//  Created by 岡崎伸也 on 2019/11/07.
//  Copyright © 2019 sample. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

/// ローカル通知に関する処理をまとめたクラス
// 参考:
// https://qiita.com/yamataku29/items/f45e77de3026d4c50016
// https://hayashi-rin.net/post-7060
class LocalNotificationManager{
    
    // 許諾ダイアログを出す
    static func requestLocalNotification(){
        if #available(iOS 10.0, *){
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .sound, .alert]){(granted, error) in
                if error != nil{
                    return
                }
                if granted{
                    print("通知許可")
                    DispatchQueue.main.async {
                        /*
                        let center = UNUserNotificationCenter.current()
                        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                            center.delegate = appDelegate
                        }
                        */
                    }
                }
            }
        }
        else{
            // iOS 9以下
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    
}
