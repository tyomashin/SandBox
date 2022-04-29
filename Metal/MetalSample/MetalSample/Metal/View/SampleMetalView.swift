//
//  SampleMetalView.swift
//  MetalSample
//
//  Created by 岡崎伸也 on 2022/04/04.
//

import Foundation
import MetalKit
import SwiftUI

/**
 MTKViewを表示する。
 */
struct SampleMetalView: UIViewRepresentable {
    
    /// MTKViewを作る
    func makeUIView(context: Context) -> MTKView {
        let view = MTKView()
        view.delegate = context.coordinator

        // 1. MTLDeviceを取得する
        // memo: MTLDevice はハードウェアとしてのGPUを抽象化したプロトコル
        view.device = MTLCreateSystemDefaultDevice()

        // test: 背景色を変更する
        view.clearColor = MTLClearColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        // 2. コマンドキューを作成する
        if let device = view.device {
            context.coordinator.setup(device: device, view: view)
        }
        
        return view
    }
    
    /// ビューの更新処理
    func updateUIView(_ uiView: MTKView, context: Context) {
        
    }
    
    /// コーディネーターを作る
    func makeCoordinator() -> SampleRenderer {
        return SampleRenderer(self)
    }
}
