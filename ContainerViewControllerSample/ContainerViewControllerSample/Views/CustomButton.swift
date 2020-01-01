//
//  CustomButton.swift
//  ContainerViewControllerSample
//
//  Created by 岡崎伸也 on 2019/09/23.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit

/// シンプルなフラットデザインボタン
class CustomButton: UIButton {

    // storyboard からの生成時に呼ばれる
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCustom()
    }
    // コードからの生成時に呼ばれる
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCustom()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    // タッチ開始時
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchStartAnimation()
    }
    // タッチ終了時
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchEndAnimation()
    }
    func initCustom(){
        // 角を丸くする
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor.blue
        //self.clipsToBounds = true
    }
}

// ボタンタップ時の処理
extension CustomButton{
    func touchStartAnimation(){
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {
            self.alpha = 0.8
        },completion: nil)
    }
    func touchEndAnimation() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {
            self.alpha = 1
        },completion: nil)
    }
}
