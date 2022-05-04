//
//  ViewController.swift
//  MetalTutorial
//
//  Created by 岡崎伸也 on 2022/04/29.
//

import UIKit
import Metal
import MetalKit

/**
 以下のチュートリアルを試したプロジェクト
 https://www.raywenderlich.com/7475-metal-tutorial-getting-started
 
 内容は、「三角形を描画する」というもの。
 
 */

class ViewController: UIViewController {
    var metalLayer: CAMetalLayer!

    /* CPUからGPUに渡すための頂点  */
    let vertexData: [Float] = [
        0.0, 1.0, 0.0,
        -1.0, -1.0, 0.0,
        1.0, -1.0, 0.0
    ]
    var vertexBuffer: MTLBuffer!
    
    // GPUの抽象プロトコル
    var device: MTLDevice!
    
    // GPUで処理するレンダーパイプラインの状態オブジェクト
    var pipelineState: MTLRenderPipelineState!
    // CPUからGPUへの命令（コマンド）を入れるためのキュー
    var commandQueue: MTLCommandQueue!
    // MetalLayer の更新タイミング（レンダリングループのためのタイマー）
    var timer: CADisplayLink!
    
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
        
        /* 3. Vertex Buffer を作成する
         ・CPUからGPUに頂点データを渡すためのバッファ。
         ・後でコマンドエンコーダーの「setVertexBuffer」or「setVertexBytes」で頂点データをセットする
         */
        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
        vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: [])
        
        /*
         4. レンダーパイプラインのセットアップ
         */
        setupPipelineStateObject()
        
        /*
         5. コマンドキューを作成
         CPUからの描画コマンドをGPUに送信するためのコマンド順序制御キュー.
         コマンドキューにコマンドバッファ（コマンドの塊）を格納して、GPUに対して処理要求する。
         
         なお、コマンドキューの生成はコストが高いので、初回のみ生成する
         （コマンドバッファの生成は軽いので、毎フレーム作成する）
         */
        commandQueue = device.makeCommandQueue()
        
        /*
         6. 三角形の描画処理
         画面のリフレッシュレートに同期したタイマーを用意して、毎フレーム三角形を描画する
         */
        setupRenderingTimer()
    }
    
    /// レンダーパイプライン状態オブジェクトのセットアップ
    /// memo: レンダーパイプラインは、GPU上でCPUからの描画コマンドを処理するためのもの
    ///       レンダーパイプラインは3つのステージに分かれている
    ///       ・Vertexステージ
    ///       ・Rasterizationステージ
    ///       ・Fragmentステージ
    private func setupPipelineStateObject() {
        /* 1. デフォルトライブラリの取得
         プロジェクトに登録されたシェーダーは、アプリのビルド時に次の流れでビルドされ、ライブラリが生成・アプリに組み込まれる。
         
           1. ソースコード（.metal）
           2. 中間オブジェクト（.air）
           3. ライブラリ（metallib）
         
         自動的にロードされたライブラリは、「device.makeDefaultLibrary()」で取得できる
         */
        let defaultLibrary = device.makeDefaultLibrary()!
        
        /* 2. シェーダー間数オブジェクトを取得 */
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
        
        /* 3. レンダーパイプライン状態オブジェクトのデスクリプタを定義
         デスクリプタは、状態オブジェクトの情報が格納される.
         
         ここでは以下を定義している。
         
         ・ラベル：動作には影響しないが、デバッグ時に便利
         ・Vertex関数：Vertexステージで実行する関数
         ・Fragment関数：Fragmentステージで実行する関数
         ・colorAttachments[0].pixelFormat：レンダーパスターゲットのピクセル形式。
                                            もしMTKViewを使っていたら、そこから取得できる. view.colorPixelFormat
         */
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.label = "Triangle Pipeline"
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        /* 4. パイプライン状態オブジェクトを生成する */
        do {
            self.pipelineState = try device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        } catch let error  {
            print(error)
        }
        
        setupRenderingTimer()
    }
    
    /// レンダリングループ用のタイマーをセットアップ
    /// memo: 画面がリフレッシュされるたびに、最新の描画情報をGPUに送信するためのタイマーを作成
    private func setupRenderingTimer() {
        timer = CADisplayLink(target: self, selector: #selector(loop))
        timer.add(to: RunLoop.main, forMode: .default)
    }
    
    
    /// 三角形の描画処理
    /// memo: 毎フレーム実行する想定
    private func renderTriangle() {
        /* 1. コマンドバッファの作成
         コマンドバッファは、「このフレームで実行するレンダリングコマンドのリスト」のこと。
         */
        guard let cmdBuffer = self.commandQueue.makeCommandBuffer() else { return }
        
        /* 2. レンダーパスデスクリプタを定義
         */
        // 前に描画したドローアブルオブジェクトを取得
        guard let drawable = metalLayer.nextDrawable() else { return }
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        // 描画前に、画面をリセットする. その時の背景色をcleaColorで指定
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 1.0, green: 0, blue: 0, alpha: 1.0)
        
        /* 3. コマンドエンコーダーを作成
         */
        guard let encoder = cmdBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        
        /* 補足：ViewPortを設定
         これもMetalへの描画コマンドの一つ
         */
        encoder.setViewport(
            MTLViewport(originX: 0, originY: 0, width: Double(self.metalLayer.frame.width), height: Double(self.metalLayer.frame.height), znear: 0.0, zfar: 1.0)
        )

        
        /* 4. コマンドエンコーダーに設定を行い、描画コマンドを実行
         
         ・パイプライン状態オブジェクトを設定
         ・Vertex関数の引数を設定
         */
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        // ViewPortのサイズを引数に渡す
        var vpSize = vector_float2(Float(self.metalLayer.frame.width / 2.0), Float(self.metalLayer.frame.height / 2.0))
        encoder.setVertexBytes(&vpSize, length: MemoryLayout<vector_float2>.size, index: 1)
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
         
        // memo: 他にVertex関数の実行が必要なら、上記の set -> draw を繰り返し行う
        let vertex1 : [Float] = [
            -100, 200, 0.0,
            -100, -200, 0.0,
            100, -200, 0.0
        ]
        let vertex1Size = vertex1.count * MemoryLayout.size(ofValue: vertex1[0])
        encoder.setVertexBytes(vertex1, length: vertex1Size, index: 0)
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        
        /* 5. エンコードを終了して、GPUにコマンドバッファをコミットする
         */
        encoder.endEncoding()
        
        cmdBuffer.present(drawable)
        cmdBuffer.commit()
    }
    
    /// 画面のリフレッシュに同期して実行する画面更新処理
    @objc func loop() {
        autoreleasepool {
          self.renderTriangle()
        }
    }
}

