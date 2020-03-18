//
//  CustomFloatGradationAndImage.swift
//  AlertDialogSample
//
//  Created by 岡崎伸也 on 2020/02/05.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import UIKit

/// 背景グラデーション、画像つきのフロートView
class CustomFloatGradationAndImage: UIView {
    
    let VIEW_MARGIN : CGFloat = 15

    @IBOutlet var baseView: UIView!
    @IBOutlet weak var contentView: GDView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var targetModel = CustomFloatManager.FloatModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCustom()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCustom()
    }
    
    private func initCustom(){
        // Nib を読み込む
        Bundle.main.loadNibNamed("CustomFloatGradationAndImage", owner: self, options: nil)
        baseView.frame = self.bounds
        addSubview(baseView)
        // 角丸にする
        contentView.layer.cornerRadius = 10
        // ラベル文字色の設定
        titleLabel.textColor = .white
        messageLabel.textColor = .white
        // ラベルの文字サイズ、フォントの設定
        titleLabel.font = UIFont.customFont(ofSize: 15, weight: .bold)
        messageLabel.font = UIFont.customFont(ofSize: 11, weight: .regular)
    }
    
    /// フロートの詳細を設定
    /// - Parameter model: 表示する情報
    func setDetails(model : CustomFloatManager.FloatModel) -> CGFloat{
        targetModel = model
        imageView.image = model.icon?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        titleLabel.text = model.title
        messageLabel.text = model.message
        // ラベルのサイズに応じてViewの高さを調整
        titleLabel.sizeToFit()
        messageLabel.sizeToFit()
        var height : CGFloat = VIEW_MARGIN * 2
        height += titleLabel.frame.height + messageLabel.frame.height
        // 背景色
        contentView.startColor = model.backgroundColorStart
        if let endColor = model.backgroundColorEnd{
            contentView.endColor = endColor
        }else{
            contentView.endColor = model.backgroundColorStart
        }
        // Todo: 生存時間のカウント
        //
        return height
    }
}
