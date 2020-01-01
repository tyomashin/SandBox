//
//  ViewController2ViewController.swift
//  ContainerViewControllerSample
//
//  Created by 岡崎伸也 on 2019/09/19.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit

class ViewController2 : BaseViewController{

    @IBOutlet weak var headerButton: HeaderButton!
    @IBOutlet weak var subHeaderButton: SubHeaderButton!
    
    
    lazy var layoutinit : Void = {
        headerButton.vcInitCustom(str : "hogeaaaaaaaaaaa")
        subHeaderButton.vcInitCustom(str : "subdesu")
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("vc2")
        // Do any additional setup after loading the view.
        _ = layoutinit
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    // ダイアログを表示
    @IBAction func showDialog(_ sender: Any) {
        let storyboard = UIStoryboard(name: "DialogViewController", bundle: nil)
        let targetViewController = storyboard.instantiateInitialViewController() as! DialogViewController
        addChild(targetViewController)
        targetViewController.view.frame = self.view.bounds
        self.view.addSubview(targetViewController.view)
        // ダイアログの表示アニメーション
        targetViewController.view.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: {
            targetViewController.view.alpha = 1.0
        }){_ in
            targetViewController.didMove(toParent: self)
        }
        //self.view.addSubview(targetViewController.view)
        //targetViewController.didMove(toParent: self)
    }
}
