//
//  ImageCollectionView.swift
//  CustomViewCollections
//
//  Created by 岡崎伸也 on 2019/10/14.
//  Copyright © 2019 sample. All rights reserved.
//

import Foundation
import UIKit

/// UIImage リストを受け取って、タグとして横並びに表示する
class ImageCollectionView : UIView{
    
    // UIImageView 間のマージン
    let IMAGEVIEW_LEADING_MARGIN : CGFloat = 10
    
    var uiimageTagList : [UIImageView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCustom()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCustom()
    }

    func initCustom(){
    }
    
    /// UIImageのリストを受け取って画面描画する
    func setUIImageTagList(imageList : [UIImage]){
        uiimageTagList = []
        for index in 0 ... imageList.count - 1{
            let image = imageList[index]
            // image のアスペクトを取得する
            let widthAspect = image.size.width/image.size.height
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            // ImageView の設定
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            self.addSubview(imageView)
            // ImageView に制約をつける
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: widthAspect).isActive = true
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            // x 軸の制約をつける
            // １つ前に imageview を追加している場合
            if uiimageTagList.indices.contains(index - 1){
                let leadingImageView = uiimageTagList[index - 1]
                imageView.leadingAnchor.constraint(equalTo: leadingImageView.trailingAnchor,
                    constant: IMAGEVIEW_LEADING_MARGIN).isActive = true
            }else{
                imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            }
            uiimageTagList.append(imageView)
        }
    }
    
}
