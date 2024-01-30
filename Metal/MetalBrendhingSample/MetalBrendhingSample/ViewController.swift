//
//  ViewController.swift
//  MetalBrendhingSample
//
//  Created by 岡崎伸也 on 2022/05/26.
//

import UIKit
import MetalKit

/**
 ブレンディングについて色々と試すためのプロジェクト。
 
 [前提知識]
 ・描画先のことを「destination」、描画元のことを「source」と呼ぶ
 ・描画先と、描画元の色を混ぜ合わせることを「ブレンディング」という
 ・不透明な色を描画する場合は、ブレンディングは考慮する必要ない（OFF）
 ・アルファ値を持つ色を描画する場合は、描画先と描画元の色を混ぜる「アルファブレンディング」を考慮する必要がある
 
 [本プロジェクトで試すこと]
 ◯ブレンディングがオフなPSO
 ・1. 不透明な色を重ね合わせる場合
     -> source の色がそのまま表示されること（ブレンドされないこと）

 ◯ブレンディングがONなPSO
 ・2. 描画先が透過度を持ち、描画元が不透明な色を重ね合わせる場合
     -> 描画元の色がそのまま表示されること
 
 ・3. 描画先が不透明で、描画元が透過度をもつ場合
     -> アルファブレンディングされること
 
 ・4. 描画先、描画元が共に透過度を持つ場合
     -> アルファブレンディングされること
 
 
 [参考文献]
   ・https://wgld.org/d/webgl/w029.html
  
 */
class ViewController: UIViewController {

    var metalLayer: CAMetalLayer!

    // GPUの抽象プロトコル
    var device: MTLDevice!
    // CPUからGPUへの命令（コマンド）を入れるためのキュー
    var commandQueue: MTLCommandQueue!
    // MetalLayer の更新タイミング（レンダリングループのためのタイマー）
    var timer: CADisplayLink!
    
    /**
     レンダーパイプライン状態オブジェクト
     Note: ここで色々なブレンディングの設定を適用する
     */
    let opaquePSODrawer = OpaquePipeLineObjectDrawer()
    let transparentPSODrawer = TransparentPipelineObjectDrawer()
    let texturePSODrawer = TexturePipelineObjectDrawer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupMetal()
        
        opaquePSODrawer.initData(view: self.view)
        transparentPSODrawer.initData(view: self.view)
        texturePSODrawer.initData(view: self.view)
    }
}

extension ViewController {
    func setupMetal() {
        /* GPUを検索する */
        device = MTLCreateSystemDefaultDevice()
        
        /* MetalLayer を初期化 */
        metalLayer = CAMetalLayer()
        metalLayer.device = device
        // ピクセルフォーマットを指定する
        metalLayer.pixelFormat = .bgra8Unorm
        metalLayer.framebufferOnly = true
        metalLayer.frame = self.view.frame
        metalLayer.contentsScale = UIScreen.main.scale
        metalLayer.backgroundColor = UIColor.clear.cgColor
        metalLayer.isOpaque = false
        view.layer.addSublayer(metalLayer)
        
        /* レンダーパイプライン状態オブジェクトを初期化する */
        let defaultLib = device.makeDefaultLibrary()!
        opaquePSODrawer.setupPSO(currentDevice: device, library: defaultLib)
        transparentPSODrawer.setupPSO(currentDevice: device, library: defaultLib)
        texturePSODrawer.setupPSO(currentDevice: device, library: defaultLib)
        
        /* コマンドキューを作成 */
        commandQueue = device.makeCommandQueue()
        
        /* レンダリングタイマーをセットする */
        timer = CADisplayLink(target: self, selector: #selector(loop))
        timer.add(to: RunLoop.main, forMode: .default)
    }
    
    /// 画面のリフレッシュに同期して実行する画面更新処理
    @objc func loop() {
        autoreleasepool {
          self.renderData()
        }
    }
    
    /// 描画処理
    /// memo: 毎フレーム実行する想定
    private func renderData() {
        let date = Date()
        
        let cmdBuffer = self.commandQueue.makeCommandBuffer()!
        
        // レンダーパスでスクリプタを定義
        let drawable = metalLayer.nextDrawable()!
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        // 描画前に画面をリセットする。その時の背景色をclearColorで指定
        // Note: 最初の描画時は、このclearColorがdestination（描画先）になる
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        // コマンドエンコーダーを作成
        let encoder = cmdBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        /* PSOごとの描画処理 */
        // opaquePSODrawer.drawPrimitives(view: self.view, encoder: encoder, currentDevice: device)
        transparentPSODrawer.drawPrimitives(view: self.view, encoder: encoder, currentDevice: device)
        // texturePSODrawer.drawPrimitives(view: self.view, encoder: encoder, currentDevice: device)
        
        // エンコードを終了して、GPUにコマンドバッファをコミットする
        encoder.endEncoding()
        
        cmdBuffer.present(drawable)
        cmdBuffer.commit()
        
        print("finish")
    }
}
