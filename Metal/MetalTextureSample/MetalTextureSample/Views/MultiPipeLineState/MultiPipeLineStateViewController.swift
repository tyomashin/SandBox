//
//  MultiPipeLineStateViewController.swift
//  MetalTextureSample
//
//  Created by 岡崎伸也 on 2022/05/25.
//

import UIKit

/**
 複数のパイプライン状態オブジェクトを管理して描画することを試す.
 
 [課題]
 ・色が重なり合った描画部分について、ブレンドせずに描画したい
     -> ImageViewが重なった時と同じ色味で描画したい
 ・半透明のテクスチャ表示について
     -> 背景の色とブレンドされる事象について確認する
 
 */
class MultiPipeLineStateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
