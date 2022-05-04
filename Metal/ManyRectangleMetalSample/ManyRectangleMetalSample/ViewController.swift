//
//  ViewController.swift
//  ManyRectangleMetalSample
//
//  Created by 岡崎伸也 on 2022/05/03.
//

import UIKit
import MetalKit

/// 大量の長方形を表示するサンプル
class ViewController: UIViewController {

    var metalLayer: CAMetalLayer!
    
    // GPUの抽象プロトコル
    var device: MTLDevice!
    // GPUで処理するレンダーパイプラインの状態オブジェクト
    var pipelineState: MTLRenderPipelineState!
    // CPUからGPUへの命令（コマンド）を入れるためのキュー
    var commandQueue: MTLCommandQueue!
    // MetalLayer の更新タイミング（レンダリングループのためのタイマー）
    var timer: CADisplayLink!
    
    // 描画データ
    // 長方形
    var vertexArray = [ShaderVertex]()
    
    // 背景描画データ
    var backgroundVertexArray = [ShaderVertex]()
    
    var viewModel = SampleViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        // Metalの設定
        setupMetal()
        
        // サンプルデータの作成
        viewModel.initSampleData(view: self, metalLayerFrame: metalLayer.frame)
        // 現在のサンプルデータから描画情報を返す
        vertexArray = viewModel.getCurrentVertexData()
        
        //viewModel.randomTimer()
        
        // ジェスチャーの登録
        // setGesture()
        
        //initData()
        
        //initBackgroundData()
        
        /*
        Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { _ in
            self.metalLayer.frame.origin.y -= 1
            self.metalLayer.frame.origin.x -= 1
        }
        */
    }
    
    /*
    /// 背景の罫線を設定
    private func initBackgroundData() {
        let baseX: Float = Float(self.view.frame.width / 2)
        let baseY: Float = Float(self.view.frame.height / 2)
        
        var leftX = Float(40) - baseX
        var rightX = Float(41) - baseX
        var topY = baseY - Float(0)
        var bottomY = baseY - Float(1000)
        
        var centerX = (rightX + leftX) / 2
        var centerY = (topY + bottomY) / 2
        var rectSizeX: Float = 0.5
        var rectSizeY: Float = 500
        
        self.vertexArray = [
            // 縦の罫線を描画
            ShaderVertex(position: vector_float2(leftX, topY), color: vector_float4(0, 0, 0, 0.2), cornerRadius: 0),
            ShaderVertex(position: vector_float2(leftX, bottomY), color: vector_float4(0, 0, 0, 0.2), cornerRadius: 0),
            ShaderVertex(position: vector_float2(rightX, bottomY),  color: vector_float4(0, 0, 0, 0.2), cornerRadius: 0),
            
            ShaderVertex(position: vector_float2(leftX, topY), color: vector_float4(0, 0, 0, 0.2), cornerRadius: 0),
            ShaderVertex(position: vector_float2(rightX, topY), color: vector_float4(0, 0, 0, 0.2), cornerRadius: 0),
            ShaderVertex(position: vector_float2(rightX, bottomY),  color: vector_float4(0, 0, 0, 0.2), cornerRadius: 0)
        ]
    }
    */
    
    private func initData() {
        
        let baseX: Float = Float(self.view.frame.width / 2)
        let baseY: Float = Float(self.view.frame.height / 2)
        
        var leftX = Float(40) - baseX
        var rightX = Float(41) - baseX
        var topY = baseY - Float(0)
        var bottomY = baseY - Float(1000)
        
        var centerX = (rightX + leftX) / 2
        var centerY = (topY + bottomY) / 2
        var rectSizeX: Float = 0.5
        var rectSizeY: Float = 500
        
        
        /* 100, 100 の正方形を描画。
            CornerRadiusの値によって角丸にしている
         */
        leftX = Float(20) - baseX
        rightX = Float(120) - baseX
        topY = baseY - Float(100)
        bottomY = baseY - Float(200)
        
        centerX = (rightX + leftX) / 2
        centerY = (topY + bottomY) / 2
        rectSizeX = 50
        rectSizeY = 50
        
        self.vertexArray += [
            ShaderVertex(
                position: vector_float2(leftX, topY), color: vector_float4(0, 0, 0, 0.8), cornerRadius: 50,
                center: vector_float2(centerX, centerY), rectSize: vector_float2(rectSizeX, rectSizeY)
            ),
            ShaderVertex(
                position: vector_float2(leftX, bottomY), color: vector_float4(0, 0, 0, 0.8), cornerRadius: 50,
                center: vector_float2(centerX, centerY), rectSize: vector_float2(rectSizeX, rectSizeY)
            ),
            ShaderVertex(
                position: vector_float2(rightX, bottomY),  color: vector_float4(0, 0, 0, 0.8), cornerRadius: 50,
                center: vector_float2(centerX, centerY), rectSize: vector_float2(rectSizeX, rectSizeY)
            ),
            
            ShaderVertex(
                position: vector_float2(leftX, topY), color: vector_float4(0, 0, 0, 0.8), cornerRadius: 50,
                center: vector_float2(centerX, centerY), rectSize: vector_float2(rectSizeX, rectSizeY)
            ),
            ShaderVertex(
                position: vector_float2(rightX, topY), color: vector_float4(0, 0, 0, 0.8), cornerRadius: 50,
                center: vector_float2(centerX, centerY), rectSize: vector_float2(rectSizeX, rectSizeY)
            ),
            ShaderVertex(
                position: vector_float2(rightX, bottomY),  color: vector_float4(0, 0, 0, 0.8), cornerRadius: 50,
                center: vector_float2(centerX, centerY), rectSize: vector_float2(rectSizeX, rectSizeY)
            )
        ]
    }
    
    /// パンジェスチャーの登録
    private func setGesture() {
        let myPanGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(self.panGesture(_:))
        )
        self.view.addGestureRecognizer(myPanGesture)
    }
    
    @objc func panGesture(_ gesture: UIPanGestureRecognizer){
        print("pan!!!")
        
        // TODO
        
        self.metalLayer.frame.origin.x -= 1
        self.metalLayer.frame.origin.y -= 1
        
    }
}

extension ViewController {
    func setupMetal() {
        /* 1. GPUを検索する */
        device = MTLCreateSystemDefaultDevice()
        
        /* 2. MetalLayer を初期化 */
        metalLayer = CAMetalLayer()
        metalLayer.device = device
        // ピクセルフォーマットを指定する
        metalLayer.pixelFormat = .bgra8Unorm
        metalLayer.framebufferOnly = true
        // metalLayer.frame = .init(x: 0, y: 0, width: 1000, height: self.view.frame.height + 1000)
        metalLayer.frame = self.view.frame
        metalLayer.contentsScale = UIScreen.main.scale
        metalLayer.backgroundColor = UIColor.clear.cgColor
        metalLayer.isOpaque = false
        view.layer.addSublayer(metalLayer)

        /* 3. レンダーパイプライン状態オブジェクトを初期化する */
        // デフォルトライブラリの取得
        let defaultLibrary = device.makeDefaultLibrary()!
        
        // シェーダー間数オブジェクトを取得
        let vertexProgram = defaultLibrary.makeFunction(name: "vertexShader")
        let fragmentProgram = defaultLibrary.makeFunction(name: "fragmentShader")
        
        // レンダーパイプライン状態オブジェクトのデスクリプタを定義
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.label = "Sample Pipeline"
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        // 透過度を有効にしているつもり
        //pipelineStateDescriptor.isAlphaToOneEnabled = true
        pipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = true
        pipelineStateDescriptor.colorAttachments[0].rgbBlendOperation = .add
        pipelineStateDescriptor.colorAttachments[0].alphaBlendOperation = .add
        pipelineStateDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
        pipelineStateDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha
        pipelineStateDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        pipelineStateDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
        
        do {
            self.pipelineState = try device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        } catch let error  {
            print(error)
        }
        
        /* 5. コマンドキューを作成 */
        commandQueue = device.makeCommandQueue()
        
        /* 6. レンダリングタイマーをセットする */
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
        
        // データが存在するかをまずチェックする
        guard vertexArray.count >= 3 else { return }
        
        /* 1. コマンドバッファの作成 */
        guard let cmdBuffer = self.commandQueue.makeCommandBuffer() else { return }
        
        /* 2. レンダーパスデスクリプタを定義 */
        // 前に描画したドローアブルオブジェクトを取得
        guard let drawable = metalLayer.nextDrawable() else { return }
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        // 描画前に、画面をリセットする. その時の背景色をcleaColorで指定
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        /* 3. コマンドエンコーダーを作成 */
        guard let encoder = cmdBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        

        /* 4. コマンドエンコーダーに設定を行う */
        encoder.setRenderPipelineState(pipelineState)
        
        // バッファを作成してGPUにメモリを確保する
        // memo: 4kb以下なら setVertexBytes が使える
        // 参考：https://qiita.com/TokyoYoshida/items/4aacaecbaca9f794974a
        let vertexBuffer = device.makeBuffer(
            bytes: vertexArray, length: MemoryLayout<ShaderVertex>.size * self.vertexArray.count, options: []
        )
        // 描画情報をVertex関数の引数を渡す
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: kShaderVertexInputIndeVertices)
        
        // ViewPortのサイズをVertex関数の引数に渡す
        var vpSize = vector_float2(Float(self.metalLayer.frame.width / 2.0), Float(self.metalLayer.frame.height / 2.0))
        encoder.setVertexBytes(&vpSize, length: MemoryLayout<vector_float2>.size, index: kShaderVertexInputIndexViewportSize)
        
        /* 5. 描画コマンド */
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexArray.count)
         
        /* 6. エンコードを終了して、GPUにコマンドバッファをコミットする */
        encoder.endEncoding()
        
        cmdBuffer.present(drawable)
        cmdBuffer.commit()
        
        print("finish", Date().timeIntervalSince(date), vertexArray.count)
    }
}
