//
//  TextImageCreater.swift
//  MetalBrendhingSample
//
//  Created by 岡崎伸也 on 2022/06/29.
//

import Foundation
import UIKit

class TextImageCreater {
    
    let textLayer = CATextLayer()
    
    func makeTextImage() -> UIImage {
        let str = randomString()
        
        // Note: 基本的にはテキスト画像は不透明（または固定）で作成する
        // -> テキスト画像自体に透過度を設定すると、透過度が変更するたびにテキスト画像を再作成しないといけないため
        // -> テキスト画像を透過させて表示する場合、描画時にアルファブレンディングするなどする（ImageViewの場合はalphaパラメータを設定）
        let attrStr = NSMutableAttributedString(string: str, attributes: [
            .font: UIFont.systemFont(ofSize: 10, weight: .bold),
            .foregroundColor: UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        ])
        textLayer.frame = .init(x: 0, y: 0, width: 100, height: 100)
        textLayer.backgroundColor = UIColor.clear.cgColor
        // textLayer.foregroundColor = UIColor.red.cgColor
        textLayer.string = attrStr
        //textLayer.string = str
        //textLayer.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        // memo: AttributedStringを使っている場合でもフォントサイズを指定しておいた方がよい。
        // -> 指定しないと、末尾の省略が発生しなかった
        textLayer.fontSize = 10
        textLayer.alignmentMode = .left
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.isWrapped = true
        textLayer.truncationMode = .end
        
        UIGraphicsBeginImageContextWithOptions(textLayer.frame.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        // !!! 以下のコードを書くとコンテキストがクリアされるらしい
        // context.clear(textLayer.frame)
        textLayer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func randomString() -> String {
        let length = Int.random(in: 1...100)
        let str = "abcdefghijklmnopqrstuあいうえおかきくけこさしすせそたちつてとなにぬねの"
        return String((0..<length).map { _ in
            return str.randomElement() ?? Character("")
        })
    }
    
}
