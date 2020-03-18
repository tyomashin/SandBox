//
//  AlertController.swift
//  AlertDialogSample
//
//  Created by 岡崎伸也 on 2020/01/26.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import Foundation
import UIKit

/// アラートダイアログの表示を担うクラス
class AlertManager{
    /// UIAlertController表示に使用する種別
    enum AlertType{
        case PositiveActionOnly
        case PositiveAndNegativeAction
    }

    /// UIAlertController表示に使用する属性オブジェクト
    struct AlertModel {
        var title : String = ""
        var message : String = ""
        var type : AlertType = .PositiveAndNegativeAction
        var tintColor : UIColor = .systemBlue
        var completer : (() -> Void)? = nil
    }
    
    /// 標準的なアラートコントローラーを表示する
    /// - Parameters:
    ///   - vc: 表示元のViewController
    ///   - alertModel: アラートの属性構造体
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - completion: Positiveボタンタップ時の処理
   static func showAlertController(vc : ViewController,
                                   alertModel : AlertModel){
        
        let alert = UIAlertController(title: alertModel.title, message: alertModel.message, preferredStyle: .alert)
        alert.view.tintColor = alertModel.tintColor
        let positiveAction = UIAlertAction(title: "OK", style: .default, handler: {_ in
            alertModel.completer?()
        })
        let negativeAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: {_ in
            
        })
        switch alertModel.type {
        case .PositiveActionOnly:
            alert.addAction(positiveAction)
            break
        case .PositiveAndNegativeAction:
            alert.addAction(positiveAction)
            alert.addAction(negativeAction)
            break
        }
        
        vc.present(alert, animated: true, completion: nil)
    }

    /// AlertContollerに似せたカスタムViewを表示する
    static func showCustomAlertController(vc : ViewController,
                                          alertModel : AlertModel){
        let storyBoard = UIStoryboard(name: "CustomAlertController", bundle: nil)
        guard let alert = storyBoard.instantiateInitialViewController() as? CustomAlertControllerViewController else {
            return
        }
        // ふわっと表示
        vc.modalTransitionStyle = .crossDissolve
        // Viewの背景を透過させる
        vc.modalPresentationStyle = .overCurrentContext
        vc.present(alert, animated: true, completion: nil)
        alert.setAlertModel(alertModel: alertModel)
    }

}

