//
//  ViewController.swift
//  GeofenceSample
//
//  Created by 岡崎伸也 on 2019/11/10.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    
    //var locationManager : LocationManager = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //locationManager.getLocationManager(targetId: 1, delegate: nil).startUpdatingLocation()
        // バックグラウンドでも位置情報を取得し続ける場合
        //locationManager.myLocationManager.allowsBackgroundLocationUpdates = true
        
        /*
        label1.text = UserDefaults.standard.string(forKey: "GEOFENCE_IN_DATE_1") ?? "nil"
        label2.text = UserDefaults.standard.string(forKey: "GEOFENCE_REGION_ID_1") ?? "nil"
        label3.text = UserDefaults.standard.string(forKey: "GEOFENCE_IN_DATE_FAMIMA") ?? "nil"
        label4.text = UserDefaults.standard.string(forKey: "GEOFENCE_REGION_ID_FAMIMA") ?? "nil"
        */
        
        label1.text = "launch : \(UserDefaults.standard.string(forKey: "LAUNCH_DATE"))" ?? "nil"
        label2.text = "finish : \(UserDefaults.standard.string(forKey: "FINISH_DATE"))" ?? "nil"
        
        label3.text = "checkin : \(UserDefaults.standard.string(forKey: "CHECKIN"))" ?? "nil"
        label4.text = "checkout : \(UserDefaults.standard.string(forKey: "CHECKOUT"))" ?? "nil"
        
        
 
        //print(locationManager.myLocationManager.monitoredRegions)
        print("monitaring_start_date : \(UserDefaults.standard.string(forKey: "MONITARING_START") ?? nil)")
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        format.timeZone   = TimeZone(identifier: "Asia/Tokyo")
        
    }
}

