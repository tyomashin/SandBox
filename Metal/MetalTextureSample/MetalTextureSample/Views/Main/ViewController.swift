//
//  ViewController.swift
//  MetalTextureSample
//
//  Created by 岡崎伸也 on 2022/05/09.
//

import UIKit
import MetalKit

class ViewController: UIViewController {

    // テクスチャのアルファ値
    let targetAlpha: Float = 0.5
    
    let textImageCreater = TextImageCreater()
    let textureCreator = TextureCreator()
    
    var metalLayer: CAMetalLayer!
    let imageView = UIImageView()
    let textLayer = CATextLayer()
    
    var textureImage: UIImage!
    
    // GPUの抽象プロトコル
    var device: MTLDevice!
    // GPUで処理するレンダーパイプラインの状態オブジェクト
    var pipelineState: MTLRenderPipelineState!
    // CPUからGPUへの命令（コマンド）を入れるためのキュー
    var commandQueue: MTLCommandQueue!
    // MetalLayer の更新タイミング（レンダリングループのためのタイマー）
    var timer: CADisplayLink!
    // テクスチャ
    var texture: MTLTexture!
    
    // 画像を表示する四角形
    var verticeArray: [ShaderVertex] = [ShaderVertex]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let sampleLayer = CALayer()
        sampleLayer.frame = .init(x: 150, y: 10, width: 3, height: self.view.frame.height)
        sampleLayer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        self.view.layer.addSublayer(sampleLayer)
        
        // Metalの設定
        setupMetal()
        
        initData()
        
        // texture = makeTexture(device: device)
        // texture = makeTextureFromAssets(device: device)
        
        let textImage = textImageCreater.makeTextImage()
        self.textureImage = textImage
        texture = textureCreator.makeTextureFromCGImage(device: device, cgImage: textImage.cgImage!)
        
        imageView.frame = .init(x: 10, y: 50, width: 100, height: 100)
        self.view.addSubview(imageView)
        imageView.image = textureImage
        imageView.alpha = CGFloat(targetAlpha)

        textLayer.frame = .init(x: 10, y: 300, width: 100, height: 100)
        self.view.layer.addSublayer(textLayer)
        textLayer.string = "sample text"
        textLayer.foregroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1).cgColor
        textLayer.opacity = targetAlpha
    }
    
    private func initData() {
        
        /*
        // 四角形の頂点の座標を計算する
        // 2つの三角形で構成する
        let wh = Float(min(self.metalLayer.frame.size.width, self.metalLayer.frame.size.height))
        
        self.verticeArray = [
            // 三角形 (1)
            ShaderVertex(position: vector_float2(-wh / 2.0, wh / 2.0),
                         color: vector_float4(1.0, 1.0, 1.0, 1.0),
                         textureCoordinate: vector_float2(0.0, 0.0)),
            ShaderVertex(position: vector_float2(-wh / 2.0, -wh / 2.0),
                         color: vector_float4(1.0, 1.0, 1.0, 1.0),
                         textureCoordinate: vector_float2(0.0, 1.0)),
            ShaderVertex(position: vector_float2(wh / 2.0, -wh / 2.0),
                         color: vector_float4(1.0, 1.0, 1.0, 1.0),
                         textureCoordinate: vector_float2(1.0, 1.0)),

            // 三角形 (2)
            ShaderVertex(position: vector_float2(wh / 2.0, -wh / 2.0),
                         color: vector_float4(1.0, 1.0, 1.0, 1.0),
                         textureCoordinate: vector_float2(1.0, 1.0)),
            ShaderVertex(position: vector_float2(-wh / 2.0, wh / 2.0),
                         color: vector_float4(1.0, 1.0, 1.0, 1.0),
                         textureCoordinate: vector_float2(0.0, 0.0)),
            ShaderVertex(position: vector_float2(wh / 2.0, wh / 2.0),
                         color: vector_float4(1.0, 1.0, 1.0, 1.0),
                         textureCoordinate: vector_float2(1.0, 0.0))
        ]
        */
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
        
        
        /* 正方形を描画。
            CornerRadiusの値によって角丸にしている
         */
        leftX = Float(100) - baseX
        rightX = Float(200) - baseX
        topY = baseY - Float(100)
        bottomY = baseY - Float(200)
        
        centerX = (rightX + leftX) / 2
        centerY = (topY + bottomY) / 2
        rectSizeX = 50
        rectSizeY = 50
        
        self.verticeArray += [
            ShaderVertex(
                position: vector_float2(leftX, topY), color: vector_float4(1, 1, 1, 1), textureCoordinate: vector_float2(0.0, 0.0), targetAlpha: targetAlpha
            ),
            ShaderVertex(
                position: vector_float2(leftX, bottomY), color: vector_float4(1, 1, 1, 1), textureCoordinate: vector_float2(0.0, 1.0), targetAlpha: targetAlpha
            ),
            ShaderVertex(
                position: vector_float2(rightX, bottomY), color: vector_float4(1, 1, 1, 1), textureCoordinate: vector_float2(1.0, 1.0), targetAlpha: targetAlpha
            ),
            
            ShaderVertex(
                position: vector_float2(leftX, topY), color: vector_float4(1, 1, 1, 1), textureCoordinate: vector_float2(0.0, 0.0), targetAlpha: targetAlpha
            ),
            ShaderVertex(
                position: vector_float2(rightX, topY), color: vector_float4(1, 1, 1, 1), textureCoordinate: vector_float2(1.0, 0.0), targetAlpha: targetAlpha
            ),
            ShaderVertex(
                position: vector_float2(rightX, bottomY), color: vector_float4(1, 1, 1, 1), textureCoordinate: vector_float2(1.0, 1.0), targetAlpha: targetAlpha
            )
        ]
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
        // let fragmentProgram = defaultLibrary.makeFunction(name: "fragmentShaderForAlphaBlending")
        let fragmentProgram = defaultLibrary.makeFunction(name: "fragmentShaderForAlphaTest")
        
        // レンダーパイプライン状態オブジェクトのデスクリプタを定義
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.label = "Sample Pipeline"
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        // デフォルト値：false
        // -> 以下のパラメータは用途が不明なのでデフォルト値指定
        pipelineStateDescriptor.isAlphaToOneEnabled = false
        pipelineStateDescriptor.isAlphaToCoverageEnabled = false

        // pipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = false
        /*
        // ブレンディング設定
        // 一般的な式：Cf = As * Cs + (1 - As) * Cd
        //    ・描画元（source）のRGB Color には、Source Alpha の係数をかける
        //    ・描画先（destination）のRGB Color には、（1 - Source Alpha）の係数をかける
        // 参考：https://metalbyexample.com/translucency-and-transparency/
        pipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = true
        // RGB, アルファそれぞれのブレンディング操作を選択する
        // -> ここではデフォルト値（add）を指定
        pipelineStateDescriptor.colorAttachments[0].rgbBlendOperation = .add
        pipelineStateDescriptor.colorAttachments[0].alphaBlendOperation = .add
        // 描画元（source）のRGB, アルファのブレンド係数を指定
        pipelineStateDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
        pipelineStateDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha
        // 描画先（destination）のRGB、アルファのブレンド係数を指定
        pipelineStateDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        pipelineStateDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
        */
        
        // Note: CoreGraphics を使用して生成した画像をテクスチャとして描画する場合
        //   -> すでにカラーチャンネルにはアルファ値が乗算されているらしい. この場合に sourceAlpha を使うと二重でアルファを乗算してしまうとのこと。
        //       なので、以下のコードではsourceAlphaをoneにしている
        // 参考：https://stackoverflow.com/questions/62091775/cgcontext-antialiasing-works-not-as-expected-when-drawing-on-transparent-backgro
        pipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = true
        // RGB, アルファそれぞれのブレンディング操作を選択する
        // -> ここではデフォルト値（add）を指定
        pipelineStateDescriptor.colorAttachments[0].rgbBlendOperation = .add
        pipelineStateDescriptor.colorAttachments[0].alphaBlendOperation = .add
        // 描画元（source）のRGB, アルファのブレンド係数を指定
        pipelineStateDescriptor.colorAttachments[0].sourceRGBBlendFactor = .one
        pipelineStateDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
        // 描画先（destination）のRGB、アルファのブレンド係数を指定
        pipelineStateDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        pipelineStateDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha

        // Note: アルファテストを行う場合は、ブレンディング設定をOFFにしておく
        // pipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = false
        
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
        
        guard verticeArray.count > 3 else { return }
        
        guard let cmdBuffer = self.commandQueue?.makeCommandBuffer() else { return }

        /* 2. レンダーパスデスクリプタを定義 */
        // 前に描画したドローアブルオブジェクトを取得
        guard let drawable = metalLayer.nextDrawable() else { return }
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        // 描画前に、画面をリセットする. その時の背景色をcleaColorで指定
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        // renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
        // renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        /* 3. コマンドエンコーダーを作成 */
        guard let encoder = cmdBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        
        if let pipeline = self.pipelineState {
            // パイプライン状態オブジェクトを設定する
            encoder.setRenderPipelineState(pipeline)
            
            // encoder.setBlendColor(red: 0, green: 0, blue: 0, alpha: 1)
            
            // Vertex関数に渡す引数を設定する
            encoder.setVertexBytes(self.verticeArray,
                                   length: MemoryLayout<ShaderVertex>.size *
                                        self.verticeArray.count,
                                   index: kShaderVertexInputIndexVertices)
            
            // ViewPortのサイズをVertex関数の引数に渡す
            var vpSize = vector_float2(Float(self.metalLayer.frame.width / 2.0), Float(self.metalLayer.frame.height / 2.0))
            encoder.setVertexBytes(&vpSize, length: MemoryLayout<vector_float2>.size, index: kShaderVertexInputIndexViewportSize)
            
            
            // テクスチャを設定する
            encoder.setFragmentTexture(self.texture!, index: kFragmentInputIndexTexture)

            // 四角形を描画する
            encoder.drawPrimitives(type: .triangle,
                vertexStart: 0, vertexCount: 6)
        }

        encoder.endEncoding()

        cmdBuffer.present(drawable)

        cmdBuffer.commit()
        
        print("finish", Date().timeIntervalSince(date))
    }
}
