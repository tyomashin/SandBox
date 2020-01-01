//
//  SampleView.swift
//  GeofenceSample
//
//  Created by 岡崎伸也 on 2019/11/10.
//  Copyright © 2019 sample. All rights reserved.
//

import Foundation
import UIKit

class SampleView : UIView{
    
    @IBOutlet var baseView: UIView!
    
    var locationManager = LocationManager()
    
    var flag = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCustom()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCustom()
    }
    func initCustom(){
        Bundle.main.loadNibNamed("SampleView", owner: self, options: nil)
        baseView.frame = self.bounds
        self.addSubview(baseView)
    }
    @IBAction func tapButton(_ sender: Any) {
        if flag == false{
            //locationManager.getLocationManager(targetId: 2).startUpdatingLocation()
            locationManager.getLocationManager(targetId: 2, delegate: nil).startUpdatingLocation()
            // バックグラウンドでは取得しない
            //locationManager.myLocationManager.allowsBackgroundLocationUpdates = false
            locationManager.createNotification(region: nil)
            flag = true
        }
        else{
            self.removeFromSuperview()
            //flag = false
        }
    }
}
