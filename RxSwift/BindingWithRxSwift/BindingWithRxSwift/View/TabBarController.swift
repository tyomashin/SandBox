//
//  TabBarController.swift
//  BindingWithRxSwift
//
//  Created by 岡崎伸也 on 2021/11/03.
//

import Foundation
import UIKit

// https://stackoverflow.com/questions/26850411/how-add-tabs-programmatically-in-uitabbarcontroller-with-swift
class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let item1 = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        let icon1 = UITabBarItem(title: "Title1", image: UIImage(systemName: "pencil"), selectedImage: UIImage(systemName: "scribble"))
        let item2 = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        let icon2 = UITabBarItem(title: "Title2", image: UIImage(systemName: "pencil.slash"), selectedImage: UIImage(systemName: "pencil.tip"))
        let item3 = UIStoryboard(name: "Third", bundle: nil).instantiateInitialViewController()
        let icon3 = UITabBarItem(title: "Title3", image: UIImage(systemName: "lasso"), selectedImage: UIImage(systemName: "lasso.sparkles"))
        
        guard let item1 = item1, let item2 = item2, let item3 = item3 else { return }
        item1.tabBarItem = icon1
        item2.tabBarItem = icon2
        item3.tabBarItem = icon3
        let controllers = [item1, item2, item3]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
    }

    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title ?? "") ?")
        return true;
    }
}
