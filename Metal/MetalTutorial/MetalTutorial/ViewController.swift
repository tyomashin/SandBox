//
//  ViewController.swift
//  MetalTutorial
//
//  Created by 岡崎伸也 on 2022/04/29.
//

import UIKit
import Metal

/**
 以下のチュートリアルを試したプロジェクト
 https://www.raywenderlich.com/7475-metal-tutorial-getting-started
 
 内容は、「三角形を描画する」というもの。
 
 */

class ViewController: UIViewController {

    /*   */
    let vertexData: [Float] = [
        0.0, 1.0, 0.0,
        -1.0, -1.0, 0.0,
        1.0, -1.0, 0.0
    ]
    var vertexBuffer: MTLBuffer!
    
    var device: MTLDevice!
    var metalLayer: CAMetalLayer!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* 1. GPUを検索する */
        device = MTLCreateSystemDefaultDevice()
        
        /* 2. MetalLayer を初期化 */
        metalLayer = CAMetalLayer()
        metalLayer.device = device
        // ピクセルフォーマットを指定する
        metalLayer.pixelFormat = .bgra8Unorm
        metalLayer.framebufferOnly = true
        metalLayer.frame = view.layer.frame
        view.layer.addSublayer(metalLayer)
        
        /* Vertex Buffer を作成する */
        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0]) // 1
        vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: []) // 2
    }

    
}

