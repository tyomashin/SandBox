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
    
    /// カスタムダイアログを表示する
    @IBAction func tapCustomDialogButton(_ sender: Any) {
        let dialogModel = CustomDialogManager.DialogModel(title: "title test",
                                                          message: "hogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehoge",
                                                          dialogButtonType: .PositiveActionOnly,
                                                          dialogStyle: .ImageAndGradationDialog,
                                                          titleColor: .accentColor,
                                                          gradationColorStart: .orangeGradationStart,
                                                          gradationColorEnd: .orangeGradationEnd)
        CustomDialogManager.showCustomDialog(vc: self, dialogModel: dialogModel)
    }
    
    @IBAction func taoCustomFloat(_ sender: Any) {
        let floatModel = CustomFloatManager.FloatModel(title: "title",
                                                       message: "hogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogekkkkkkkkkkkkkkkkkkkkkkk",
                                                       icon: UIImage(named: "iconmonstr-school-26-240"),
                                                       backgroundColorStart: .orangeGradationStart,
                                                       backgroundColorEnd: .orangeGradationEnd,
                                                       aliveTime: 3)
        CustomFloatManager.showFloatMessage(vc: self, type: .GradationAndImage, model: floatModel)
    }
    
}

