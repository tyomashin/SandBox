//
//  ViewController.swift
//  LocalNotificationSample
//
//  Created by 岡崎伸也 on 2019/11/07.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        LocalNotificationManager.requestLocalNotification()
    }


}

