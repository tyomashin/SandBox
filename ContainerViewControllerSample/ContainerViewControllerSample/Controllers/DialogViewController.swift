//
//  DialogViewController.swift
//  ContainerViewControllerSample
//
//  Created by 岡崎伸也 on 2019/09/22.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit

class DialogViewController: UIViewController {

    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func touchCloseButton(_ sender: Any) {
        // ダイアログを閉じる
        willMove(toParent: nil)
        UIView.animate(withDuration: 0.5, animations: {
            //self.view.alpha = 0
            //self.view.center.y += self.view.bounds.height
            self.backgroundView.alpha = 0
            self.dialogView.center.y += self.view.bounds.height
            self.closeButton.center.y += self.view.bounds.height
        }, completion: {_ in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
}
