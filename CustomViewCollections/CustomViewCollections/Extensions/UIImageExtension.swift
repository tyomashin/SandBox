//
//  UIImageExtension.swift
//  CustomViewCollections
//
//  Created by 岡崎伸也 on 2019/10/03.
//  Copyright © 2019 sample. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    func resize(size _size: CGSize) -> UIImage? {
        let widthRatio = _size.width / size.width
        let heightRatio = _size.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio

        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0) // 変更
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
    
    /// 画像の左上にアイコンをつける
    /// - Parameter image: ベース画像
    /// - Parameter labelImage:付加するアイコン画像
    /// - Parameter heightRatio: アイコン画像の比率
    func attachLabelToImage(image : UIImage, labelImage : UIImage, heightRatio : CGFloat) -> UIImage{
        
        //UIGraphicsBeginImageContextWithOptions(CGSize(width: image.size.width, height: image.size.height), false, 0)
        // 描画開始
        //UIGraphicsGetCurrentContext()
        //ctx.saveGState()
        UIGraphicsBeginImageContext(CGSize(width: image.size.width*100, height: image.size.height*100))
        let rect = CGRect(x: 0, y: 0, width: image.size.width*100, height: image.size.height*100)
        image.draw(in: rect)
        /*
        let iconHeight = image.size.height * heightRatio
        let labelImageAspect = labelImage.size.width / labelImage.size.height
        let iconWidth = iconHeight * labelImageAspect
        let iconRect = CGRect(x: 0, y: 0, width: iconWidth, height: iconHeight)
        labelImage.draw(in: iconRect)
        let iconRect2 = CGRect(x: iconWidth, y: 0, width: iconWidth, height: iconHeight)
        labelImage.draw(in: iconRect2)
        */
        //ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        // 描画終了
        //UIGraphicsEndImageContext()
        
        return img!
    }
}

