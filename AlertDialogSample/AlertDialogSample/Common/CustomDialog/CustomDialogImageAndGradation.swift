//
//  CustomDialogImageAndGradation.swift
//  AlertDialogSample
//
//  Created by 岡崎伸也 on 2020/01/28.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import Foundation
import UIKit

/*
 カスタムダイアログ
 ・画像
 ・グラデーション背景のボタン
 **/
class CustomDialogImageAndGradation : UIViewController{
    
    let MAX_MAIN_IMAGEVIEW_HEIGHT : CGFloat = 100
    
    let BUTTON_AREA_HEIGHT_TWICE : CGFloat = 80
    
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var buttonAreaView: UIStackView!
    @IBOutlet weak var buttonAreaViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var positiveButton: GDButton!
    @IBOutlet weak var negativeButton: UIButton!
    
    var dialogModel = CustomDialogManager.DialogModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dialogView.layer.cornerRadius = 25
    }
    
    /// ダイアログの詳細を受け取る
    func setDialogModel(model : CustomDialogManager.DialogModel){
        self.dialogModel = model
        setBackgroundBlur()
        setImageViewConstraint()
        setButtonAreaConstraint()
        setButtonDetail()
        setMessageDetail()
    }
    @IBAction func tapPositiveButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        dialogModel.completion?()
    }
    @IBAction func tapNegativeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 画像のアスペクト比に応じて制約を変更する
    /// memo: 画像の高さは、ダイアログ生成時に用意する画像に応じて呼び出し元が決定すること。
    private func setImageViewConstraint(){
        mainImageView.contentMode = .scaleAspectFit
        guard let image = dialogModel.mainImage else{
            return
        }
        mainImageView.image = image
        let aspect = image.size.width/image.size.height
        if dialogModel.mainImageViewHeight <= MAX_MAIN_IMAGEVIEW_HEIGHT{
            mainImageViewHeightConstraint.constant = dialogModel.mainImageViewHeight
            mainImageViewWidthConstraint.constant = dialogModel.mainImageViewHeight * aspect
        }else{
            mainImageViewHeightConstraint.constant = MAX_MAIN_IMAGEVIEW_HEIGHT
            mainImageViewWidthConstraint.constant = MAX_MAIN_IMAGEVIEW_HEIGHT * aspect
        }
        dialogView.layoutIfNeeded()
    }
    
    /// 画像領域の高さを
    private func setButtonAreaConstraint(){
        switch dialogModel.dialogButtonType {
        case .PositiveActionOnly:
            buttonAreaViewHeightConstraint.constant = BUTTON_AREA_HEIGHT_TWICE / 2
            negativeButton.isHidden = true
            buttonAreaView.layoutIfNeeded()
            positiveButton.layoutIfNeeded()
            break
        case .PositiveAndNegativeAction:
            buttonAreaViewHeightConstraint.constant = BUTTON_AREA_HEIGHT_TWICE
            break
        }
    }
    
    /// ボタンの設定
    private func setButtonDetail(){
        positiveButton.setTitle("ok_button".localized, for: .normal)
        negativeButton.setTitle("cancel_button".localized, for: .normal)
        positiveButton.tintColor = .white
        negativeButton.tintColor = .textColor
        positiveButton.cornerRadius = 20
        // グラデーション
        if let gradationColorStart = dialogModel.gradationColorStart,
            let gradationColorEnd = dialogModel.gradationColorEnd {
            positiveButton.startColor = gradationColorStart
            positiveButton.endColor = gradationColorEnd
        }
    }
    
    /// ラベルの設定
    private func setMessageDetail(){
        titleLabel.textColor = dialogModel.titleColor
        messageLabel.textColor = .textColor
        titleLabel.text = dialogModel.title
        messageLabel.text = dialogModel.message
    }
    
    /// 背景の設定
    private func setBackgroundBlur(){
        let blurEffect = UIBlurEffect(style: .extraLight)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.frame
        self.view.addSubview(visualEffectView)
        self.view.sendSubviewToBack(visualEffectView)
    }
}
