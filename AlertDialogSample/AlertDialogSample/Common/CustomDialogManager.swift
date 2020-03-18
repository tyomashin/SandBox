//
//  DialogManager.swift
//  AlertDialogSample
//
//  Created by 岡崎伸也 on 2020/01/27.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import Foundation
import UIKit

/// カスタムダイアログの表示を担うクラス
class CustomDialogManager{
    
    /// ダイアログの種別
    enum DialogButtonType{
        case PositiveActionOnly // ボタン一つ
        case PositiveAndNegativeAction // ボタン二つ
    }
    
    /// ダイアログのスタイル
    enum DialogStyle{
        case ImageAndGradationDialog // 画像つき、及びグラデーションカラーを使用
    }
    
    /// カスタムダイアログの設定構造体
    struct DialogModel{
        var title = ""
        var message = ""
        var dialogButtonType : DialogButtonType = .PositiveAndNegativeAction
        var dialogStyle : DialogStyle = .ImageAndGradationDialog
        var mainImage : UIImage? = UIImage(named: "dialog_default")
        var mainImageViewHeight : CGFloat = 150
        var titleColor : UIColor = .yellow
        var gradationColorStart : UIColor? = .yellow
        var gradationColorEnd : UIColor? = .orange
        var completion : (()->Void)? = nil
    }
    
    /// カスタムダイアログを表示する
    /// - Parameters:
    ///   - vc: 表示元のViewController
    ///   - dialogModel: カスタムダイアログの内容
    static func showCustomDialog(vc : ViewController, dialogModel : DialogModel){
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        switch dialogModel.dialogStyle {
            // 「画像つき、かつグラデーションボタンを使用したダイアログ」「画像なしダイアログ」
        case .ImageAndGradationDialog:
            let storyBoard = UIStoryboard(name: "CustomDialogImageAndGradation", bundle: nil)
            guard let dialog = storyBoard.instantiateInitialViewController() as? CustomDialogImageAndGradation else {
                return
            }
            vc.present(dialog, animated: true, completion: nil)
            dialog.setDialogModel(model: dialogModel)
            break
        }
    }
}
