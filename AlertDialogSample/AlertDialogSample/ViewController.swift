//
//  ViewController.swift
//  AlertDialogSample
//
//  Created by 岡崎伸也 on 2020/01/26.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.modalPresentationStyle = .fullScreen
    }

    /// シンプルなAlertContollerを表示
    @IBAction func tapAlertControllerButton(_ sender: Any) {
        let alertModel = AlertManager.AlertModel(title: "title",
                                                 message: "message",
                                                 type: .PositiveAndNegativeAction,
                                                 tintColor: .orange,
                                                 completer: nil)
        
        AlertManager.showAlertController(vc: self, alertModel: alertModel)
    }
    
    /// AlertControllerに寄せたDialogを表示
    /// - AlertControllerにカスタムViewを挿入したかった
    @IBAction func tapCustomAlertButton(_ sender: Any) {
        let alertModel = AlertManager.AlertModel(title: "title",
                                                 message: "message",
                                                 type: .PositiveAndNegativeAction,
                                                 tintColor: .orange,
                                                 completer: nil)
        AlertManager.showCustomAlertController(vc: self, alertModel: alertModel)
    }
}

