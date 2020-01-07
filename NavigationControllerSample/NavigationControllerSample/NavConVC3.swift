//
//  NavConVC3.swift
//  NavigationControllerSample
//
//  Created by 岡崎伸也 on 2020/01/08.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import Foundation
import UIKit

/// ・ナビゲーションバーを表示する
/// ・ボタンタップで新しいNavigationControllerを起動する
class NavConVC3 : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapNewButton(_ sender: Any) {
        // Todo：新しいTabbarViewControllerを起動する
        let storyboard = UIStoryboard(name: "NavConVC1", bundle: nil)
        let nextVC = storyboard.instantiateInitialViewController()!
        let navContoller = UINavigationController(rootViewController: nextVC)
        self.present(navContoller, animated: true, completion: nil)
    }
}

