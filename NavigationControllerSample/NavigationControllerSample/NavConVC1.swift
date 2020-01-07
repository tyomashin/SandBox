//
//  NavConVC1.swift
//  NavigationControllerSample
//
//  Created by 岡崎伸也 on 2020/01/08.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import Foundation
import UIKit


/// ナビゲーションバーを非表示にする
class NavConVC1 : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // ナビゲーションバーを非表示にする
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    @IBAction func tapNextButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "NavConVC2", bundle: nil)
        let nextVC = storyboard.instantiateInitialViewController()!
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
