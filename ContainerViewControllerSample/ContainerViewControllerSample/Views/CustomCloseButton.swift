//
//  CustomCloseButton.swift
//  ContainerViewControllerSample
//
//  Created by 岡崎伸也 on 2019/09/23.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit

/// バツボタン
class CustomCloseButton: UIButton {
    
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
    }
    // タッチ終了時
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    func initCustom(){
        // 角を丸くする
        //self.layer.cornerRadius = 5
        //self.clipsToBounds = true
        //self.setTitleColor(UIColor.white, for: UIControl.State.normal)
        // 画像の色を変更
        self.tintColor = UIColor.gray
        // ボタンを角丸にする
        self.layer.cornerRadius = self.frame.size.width / 2
        // 画像の指定
        let image = UIImage(named: "CancelIcon")
        self.setImage(image, for: UIControl.State.normal)
        // ボタンいっぱいに画像を表示
        self.imageView?.contentMode = .scaleAspectFit
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
        // テキストを非表示
        self.setTitle("", for: UIControl.State.normal)
    }
}
