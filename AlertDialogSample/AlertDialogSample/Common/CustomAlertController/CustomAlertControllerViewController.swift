//
//  CustomAlertControllerViewController.swift
//  AlertDialogSample
//
//  Created by 岡崎伸也 on 2020/01/26.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import UIKit

/*
 ・背景色を透過させる
 　：.modalPresentationStyle = .overCurrentContext
 ・遷移時にふわっと表示させる
 　：.modalPresentationStyle = .overCurrentContext
 
  # Storyboad
 　・高さに固定制約ではなく、>=の制約のみをつけるdialogViewを作成する
 　・任意のカスタムViewをaddする領域contentViewの高さを固定値とし、その制約をIBOutletで結ぶ。
 　　カスタムViewの高さはコードで決めて、制約のconstantに代入する。
 　・ButtonAreaViewはStackViewで作成
 */
class CustomAlertControllerViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonAreaView: UIStackView!
    @IBOutlet weak var negativeButton: UIButton!
    @IBOutlet weak var positiveButton: UIButton!
    
    var alertModel : AlertManager.AlertModel = AlertManager.AlertModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dialogView.layer.cornerRadius = 10
        
        negativeButton.setTitle("Cancel", for: .normal)
        positiveButton.setTitle("OK", for: .normal)
        negativeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    @IBAction func tapNegativeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tapPositiveButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 表示内容をセットする
    /// - Parameter alertModel: 表示内容
    func setAlertModel(alertModel : AlertManager.AlertModel){
        self.alertModel = alertModel
        messageLabel.text = alertModel.message
        // ボタンの数
        switch alertModel.type {
        case .PositiveActionOnly:
            negativeButton.isHidden = true
            break
        case .PositiveAndNegativeAction:
            break
        }
        // ボタンの色など
        self.positiveButton.tintColor = alertModel.tintColor
        self.negativeButton.tintColor = alertModel.tintColor
        // ボタンタップ時
        negativeButton.addTarget(self,
                                 action: #selector(self.tapCustomAlertControllerPositiveButton(_:)),
                                 for: .touchUpInside)
        // コンテンツViewを設定
        setContentView()
        // ボタンエリアのlayer設定
        setButtonAreaLayer(type: alertModel.type)
    }
    
    @objc private func tapCustomAlertControllerPositiveButton(_ sender : UIButton){
        alertModel.completer?()
    }
    
    /// ContentViewエリアにViewを追加
    private func setContentView(){
        let customImageView = CustomImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        contentView.addSubview(customImageView)
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        customImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        customImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        customImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        customImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        contentViewHeightConstraint.constant = 100
    }
    
    private func setButtonAreaLayer(type : AlertManager.AlertType){
        let topBorder = CALayer(layer: buttonAreaView.layer)
        topBorder.frame = CGRect(x: 0, y: 0, width: buttonAreaView.frame.width, height: 0.5)
        topBorder.backgroundColor = UIColor.lightGray.cgColor
        buttonAreaView.layer.addSublayer(topBorder)
        if type == .PositiveAndNegativeAction{
            let centerBorder = CALayer(layer: buttonAreaView.layer)
            centerBorder.frame = CGRect(x: buttonAreaView.center.x, y: 0, width: 0.5, height: buttonAreaView.frame.height)
            centerBorder.backgroundColor = UIColor.lightGray.cgColor
            buttonAreaView.layer.addSublayer(centerBorder)
        }
    }
    
}
