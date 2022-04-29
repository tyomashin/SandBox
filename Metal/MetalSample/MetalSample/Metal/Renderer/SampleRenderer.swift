//
//  SampleRenderer.swift
//  MetalSample
//
//  Created by 岡崎伸也 on 2022/04/03.
//

import Foundation
import MetalKit

/**
 Metal を使った処理を実装するクラス。
 ・MTKViewDelegate プロトコルの準拠クラス
 */
class SampleRenderer: NSObject, MTKViewDelegate {
    
    let parent: SampleMetalView
    // CPUからGPUへ送信するコマンドバッファを積むキュー
    // memo: コマンドバッファの実行順を管理するキュー
    var commandQueue: MTLCommandQueue?
    // レンダーパイプライン状態オブジェクト
    var pipelineState: MTLRenderPipelineState?
    // ビューポートサイズ
    var viewportSize: CGSize = CGSize()
    
    var vertices: [ShaderVertex] = [ShaderVertex]()
    
    init(_ parent: SampleMetalView) {
        self.parent = parent
    }
    
    func setup(device: MTLDevice, view: MTKView) {
        // 2. コマンドバッファの実行順を管理するキュー
        // memo: CPUからGPUに「コマンドバッファ：コマンドを格納するコンテナ」を送信し、GPUではコマンドバッファを実行して画面描画する
        self.commandQueue = device.makeCommandQueue()
        
        // レンダーパイプライン状態オブジェクトを用意する
        setupPipelineState(device: device, view: view)
    }
    
    /// Viewのサイズが変わる時に呼ばれる
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.viewportSize = size
    }
    
    /// Viewの内容を描画する必要があるときに呼ばれる
    func draw(in view: MTKView) {
        // 3. コマンドバッファを作成する
        // memo: 「コマンドバッファ」は、GPUへのコマンドをまとめたコンテナ。コマンドバッファは再利用できないので、描画のたびに作成する必要あり。
        guard let cmdBuffer = self.commandQueue?.makeCommandBuffer() else { return }
        
        // 4. コマンドエンコーダーを作成する
        /**
         memo: 「前提知識」
         　GPU に送信される一連の描画コマンドのことを「レンダーパス」と呼ぶ。
         　GPU に送信された描画コマンドの実行結果は、「テクスチャ」と呼ばれるメモリバッファに格納される。
         　「テクスチャ」はGPUから読み書き可能なメモリバッファであり、イメージデータを格納する。
         */
        
        // レンダーパスデスクリプタを作成する
        guard let renderPassDesc = view.currentRenderPassDescriptor else { return }
        // コマンドバッファからコマンドエンコーダを作成する
        /**
         memo: 「コマンドエンコーダ」について
         
         コマンドエンコーダは、コマンドをコマンドバッファに追加するもの。
         4種類ある。
         ・MTLRenderCommandEncoder：グラフィックスレンダリングコマンドをエンコードする
         ・MTLComputeCommandEncoder：並列演算処理をエンコードする
         ・MTLBlitCommandEncoder：バッファ・テクスチャ間のコピー処理をエンコードする
         ・MTLParallelRenderCommandEncoder：並列実行する複数のグラフィックスレンダリングコマンドをエンコードする
         */
        //
        guard let encoder = cmdBuffer.makeRenderCommandEncoder(descriptor: renderPassDesc) else { return }
        
        // Metal にビューポートを設定
        // memo: 中心が(0,0)、横幅と高さがドローアブルのサイズ、Z座標で手前が0.0、奥が1.0を指定。
        encoder.setViewport(MTLViewport(originX: 0, originY: 0, width: self.viewportSize.width, height: self.viewportSize.height, znear: 0.0, zfar: 1.0))
        
        // コマンドのエンコードを完了する
        // memo: テクスチャにイメージが書き込まれる
        encoder.endEncoding()
        
        
        // 5. テクスチャをビューに表示する
        // memo: present() は、ドローアブルオブジェクトのテクスチャをViewに表示させる。
        // memo: ただし、present() を呼ぶタイミングは「コマンドバッファの実行完了直後( == commit 後)」。
        //       -> このため、コマンドバッファ実行後に自動的に present が呼ばれるようにスケジュールする「present(_ drawable: MTLDrawable)」を使う。
        
        // ドローアブルオブジェクトを取得する
        // memo: CAMetalDrawable クラスは、MTLDrawable の適合クラスで、CAのレイヤーに関連付けされたドローアブルオブジェクト
        // 　　　これを使うことでMTKViewにテクスチャを表示できる
        if let drawable = view.currentDrawable {
            cmdBuffer.present(drawable)
        }
        
        // 6. コマンドバッファを実行する（レンダーパスを実行する）
        // memo: コマンドバッファをGPUに送信する
        cmdBuffer.commit()
    }
    
    
    
    
    /// レンダーパイプライン状態オブジェクトを準備する
    /// memo: 「レンダーパイプライン状態オブジェクト」は、GUI上のレンダーパイプラインで実行する描画コマンドを入れるためのもの。
    /**
     memo:
     「レンダーパイプライン」について
     GPU上で、CPUからのコマンドバッファを処理して、レンダーパスターゲットに結果を書き込む。
     レンダーパイプラインは、大まかに３つのステージに分かれている。
     ・Vertexステージ：頂点ステージ
     ・Rasterizationステージ：ピクセルごとの色を計算する
     ・Fragmentステージ：ピクセルごとの色を変更するステージ。
     　　　　　　　　　　Rasterozationステージで頂点の色が計算され、その中間色をこのステージで計算する（グラデーション）
     */
    func setupPipelineState(device: MTLDevice, view: MTKView) {
        // 0. デフォルトライブラリを取得する
        /**
         プロジェクトに登録されたシェーダーは、アプリビルド時に以下の流れでビルドされてライブラリが生成 -> アプリに組み込まれる。
         　・ソースコード（.metal） -> 中間オブジェクト（.air） -> ライブラリ（.metallib）
         このように自動的にロードされたライブラリは、デフォルトライブラリとして取得できる。
         */
        guard let library = device.makeDefaultLibrary() else { return }
                
        // 1. ライブラリからシェーダー関数オブジェクトなどを取得する
        // memo: metalファイルで実装したシェーダー関数
        guard let vertexFunc = library.makeFunction(name: "vertexShader"), let fragmentFunc = library.makeFunction(name: "fragmentShader") else { return }
        
        // 2. パイプライン状態オブジェクトを初期化する
        // memo: オブジェクトの情報をデスクリプタ「MTLRenderPipelineDescriptor」で定義する
        let pipelineStateDesc = MTLRenderPipelineDescriptor()
        pipelineStateDesc.label = "Triangle Pipeline"
        // Vertexステージで実行する関数を入れる
        pipelineStateDesc.vertexFunction = vertexFunc
        // Fragmentステージで実行する関数を入れる
        pipelineStateDesc.fragmentFunction = fragmentFunc
        // レンダーパスターゲットのピクセル形式。MTKViewから取得する
        pipelineStateDesc.colorAttachments[0].pixelFormat = view.colorPixelFormat
        
        do {
            self.pipelineState = try device.makeRenderPipelineState(descriptor: pipelineStateDesc)
        } catch let error {
            print(error)
        }
    }
}
