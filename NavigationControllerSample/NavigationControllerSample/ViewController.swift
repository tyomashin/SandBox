//
//  ViewController.swift
//  NavigationControllerSample
//
//  Created by 岡崎伸也 on 2020/01/08.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func touchNavConButton(_ sender: Any) {
        // NavigationController を親にする
        let storyboard = UIStoryboard(name: "NavConVC1", bundle: nil)
        let nextVC = storyboard.instantiateInitialViewController()!
        let navContoller = UINavigationController(rootViewController: nextVC)
        self.present(navContoller, animated: true, completion: nil)
    }
    
    @IBAction func tapTabConButton(_ sender: Any) {
    }
}

