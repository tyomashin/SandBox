//
//  ViewController.swift
//  SampleWebView
//
//  Created by 岡崎伸也 on 2020/08/13.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let url = URL(string: "https://google.com"){
            let request = URLRequest(url: url)
            webview.load(request)
        }
    }


}

