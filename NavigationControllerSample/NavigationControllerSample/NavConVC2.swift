//
//  NavConVC2.swift
//  NavigationControllerSample
//
//  Created by 岡崎伸也 on 2020/01/08.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import Foundation
import UIKit

/// ・ナビゲーションバーを表示する
/// ・前画面に戻らないようにする
class NavConVC2 : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // 戻るボタンを非表示
        self.navigationItem.hidesBackButton = true
    }
    @IBAction func tapNextButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "NavConVC3", bundle: nil)
        let nextVC = storyboard.instantiateInitialViewController()!
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
}
