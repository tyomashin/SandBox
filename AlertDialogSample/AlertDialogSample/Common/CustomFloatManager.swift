//
//  CustomFloatManager.swift
//  AlertDialogSample
//
//  Created by 岡崎伸也 on 2020/02/05.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import Foundation
import UIKit

/// ユーザにメッセージを通知するフロートView表示に関するマネージャ
class CustomFloatManager{
    
    static let ANIMATION_DURATION : TimeInterval = 0.3
    
    // フロートの種類
    enum FloatType{
        case GradationAndImage
    }
    
    // フロートに表示するメッセージ
    struct FloatModel{
        var title = ""
        var message = ""
        var icon : UIImage? = nil
        var backgroundColorStart : UIColor = .accentColor
        var backgroundColorEnd : UIColor? = nil
        var aliveTime : Double = 3
    }
    
    // アニメーション用の構造体
    struct FloatAnimationModel{
        var aliveTime : Double = 3
        var moveY : CGFloat = 0
        var floatView : UIView? = nil
    }
    
    //static var timerDic : [Timer : FloatModel] = [:]
    
    /// フロートを表示する
    /// - Parameters:
    ///   - type: フロート種別
    ///   - model: 表示する内容
    static func showFloatMessage(vc : UIViewController, type : FloatType, model : FloatModel){
        switch type {
        case .GradationAndImage:
            if let rootVC = vc.view.window?.rootViewController{
                let floatView = CustomFloatGradationAndImage(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                floatView.alpha = 0
                rootVC.view.addSubview(floatView)
                floatView.translatesAutoresizingMaskIntoConstraints = false
                floatView.leadingAnchor.constraint(equalTo: rootVC.view.leadingAnchor, constant: 20).isActive = true
                floatView.bottomAnchor.constraint(equalTo: rootVC.view.bottomAnchor, constant: -40).isActive = true
                floatView.trailingAnchor.constraint(equalTo: rootVC.view.trailingAnchor, constant: -20).isActive = true
                let height = floatView.setDetails(model: model)
                floatView.heightAnchor.constraint(equalToConstant: height).isActive = true
                floatView.layoutIfNeeded()
                let animationModel = FloatAnimationModel(aliveTime: model.aliveTime,
                                                         moveY: floatView.frame.height + 40, floatView: floatView)
                animateFloat(vc: vc, animationModel: animationModel)
            }
            break
        }
        
    }
    
    /// フロートの表示アニメーション
    static func animateFloat(vc : UIViewController, animationModel : FloatAnimationModel){
        guard let floatView = animationModel.floatView else{
            return
        }
        floatView.center.y += animationModel.moveY
        let startAnimation = {
            floatView.alpha = 1.0
            floatView.center.y -= animationModel.moveY
        }
        UIView.animate(withDuration: ANIMATION_DURATION, animations: startAnimation){_ in
            // タイマーを起動して非表示アニメーションを定義
            Timer.scheduledTimer(withTimeInterval: animationModel.aliveTime, repeats: false){tmpTimer in
                let endAnimation = {
                    floatView.alpha = 0.0
                    floatView.center.y += animationModel.moveY
                }
                UIView.animate(withDuration: ANIMATION_DURATION, animations: endAnimation){_ in
                    floatView.removeFromSuperview()
                }
            }
        }
    }
}
