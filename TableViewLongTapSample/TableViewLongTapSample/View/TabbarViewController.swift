//
//  TabbarViewController.swift
//  TableViewLongTapSample
//
//  Created by 岡崎伸也 on 2022/03/16.
//

import Foundation
import UIKit

class TabbarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // タブバーアイテムの画像とタイトル間のオフセット
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 5)
    }

    func setupVCs(vcs: [UIViewController]) {
        viewControllers = vcs
    }

    func createNavController(rootVC: UIViewController, tabTitle: String, tabImage: UIImage?) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootVC)
        nav.tabBarItem.title = tabTitle
        nav.tabBarItem.image = tabImage?.withRenderingMode(.alwaysOriginal).withTintColor(.lightGray)
        nav.tabBarItem.selectedImage = tabImage?.withRenderingMode(.alwaysOriginal).withTintColor(.systemBlue)
        // 文字の選択時・未選択時の色・フォントを指定
        let tabBarAppearance = UITabBarAppearance()
        let tabBarItemAppearance = UITabBarItemAppearance()

        tabBarItemAppearance.normal.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 10), .foregroundColor: UIColor.lightGray]
        tabBarItemAppearance.selected.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 10), .foregroundColor: UIColor.systemBlue]
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        nav.tabBarItem.standardAppearance = tabBarAppearance
        // nav.tabBarItem.scrollEdgeAppearance = tabBarAppearance

        return nav
    }
}
