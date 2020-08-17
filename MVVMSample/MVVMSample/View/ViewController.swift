//
//  ViewController.swift
//  MVVMSample
//
//  Created by 岡崎伸也 on 2020/08/05.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    let mainViewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapRandomButton(_ sender: Any) {
    }
    
    
    @IBAction func tapNextPage(_ sender: Any) {
    }
    
}

