//
//  TransparentPipelineObjectDrawer.swift
//  MetalBrendhingSample
//
//  Created by 岡崎伸也 on 2022/05/26.
//

import Foundation
import MetalKit

/**
 2. ブレンディングが有効なパイプライン状態オブジェクト描画クラス
 
 ・ブレンディング設定はON
     - アルファ値を考慮する必要がある
        -> アルファブレンディングされる
 
 ・以下のケース全ての動作を確認する
     1. 描画先が透過度を持ち、描画元が不透明な色を重ね合わせる場合
       -> 描画元の色がそのまま表示されること
 
     2. 描画先が不透明で、描画元が透過度をもつ場合
       -> アルファブレンディングされること
 
     3. 描画先、描画元が共に透過度を持つ場合
       -> アルファブレンディングされること
 
 */
class TransparentPipelineObjectDrawer {
    // GPUで処理するレンダーパイプラインの状態オブジェクト
    var pipelineState: MTLRenderPipelineState!
    
    // サンプルの描画データ
    var vertexArray = [ShaderVertex]()
    
    /// パイプライン状態オブジェクトを初期化する
    func setupPSO(currentDevice: MTLDevice, library: MTLLibrary) {
        // シェーダー間数オブジェクトを取得
        let vertexProgram = library.makeFunction(name: "vertexShader")
        let fragmentProgram = library.makeFunction(name: "fragmentShader")
        
        // PSOのデスクリプタを定義
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.label = "OpaquePipeLineObjectDrawer"
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        // アルファ値周りの設定値.
        // 基本は使わないので（用途がわからない）ため、デフォルトはfalse
        pipelineStateDescriptor.isAlphaToOneEnabled = false
        pipelineStateDescriptor.isAlphaToCoverageEnabled = false
        
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
        
        do {
            self.pipelineState = try currentDevice.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        } catch {
            print("error", error)
        }
    }
    
    /// 描画処理
    func drawPrimitives(view: UIView, encoder: MTLRenderCommandEncoder, currentDevice: MTLDevice) {
        guard vertexArray.count >= 6 else { return }
        
        // コマンドエンコーダーに設定を行う
        encoder.setRenderPipelineState(pipelineState)
        
        // バッファを作成してGPUにメモリを確保する
        let vertexBuffer = currentDevice.makeBuffer(bytes: vertexArray, length: MemoryLayout<ShaderVertex>.size * vertexArray.count, options: [])
        // 描画情報をVertex関数の引数に渡す
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: kShaderVertexInputIndexVertices)
        
        // ViewPortのサイズをVertex関数に渡す
        var vpSize = vector_float2(Float(view.frame.width / 2), Float(view.frame.height / 2))
        encoder.setVertexBytes(&vpSize, length: MemoryLayout<vector_float2>.size, index: kShaderVertexInputIndexViewportSize)
        
        // 描画コマンド実行
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexArray.count)
    }
    
    func initData(view: UIView) {
        let baseX: Float = Float(view.frame.width / 2)
        let baseY: Float = Float(view.frame.height / 2)
        
        var leftX = Float(20) - baseX
        var rightX = Float(100) - baseX
        var topY = baseY - Float(180)
        var bottomY = baseY - Float(260)
        
        /**
         1. 描画先が透過度を持ち、描画元が不透明な色を重ね合わせる場合
           -> 描画元の色がそのまま表示されること
         */
        // 透明な赤い長方形
        // -> clearColor の上に塗る
        self.vertexArray += [
            ShaderVertex(
                position: vector_float2(leftX, topY), color: vector_float4(1, 0, 0, 0.5)
            ),
            ShaderVertex(
                position: vector_float2(leftX, bottomY), color: vector_float4(1, 0, 0, 0.5)
            ),
            ShaderVertex(
                position: vector_float2(rightX, bottomY),  color: vector_float4(1, 0, 0, 0.5)
            ),
            
            ShaderVertex(
                position: vector_float2(leftX, topY), color: vector_float4(1, 0, 0, 0.5)
            ),
            ShaderVertex(
                position: vector_float2(rightX, topY), color: vector_float4(1, 0, 0, 0.5)
            ),
            ShaderVertex(
                position: vector_float2(rightX, bottomY),  color: vector_float4(1, 0, 0, 0.5)
            )
        ]
        
        // 不透明な青い長方形
        // -> 透明な赤い長方形の上から重ねて塗る
        leftX = Float(30) - baseX
        rightX = Float(110) - baseX
        topY = baseY - Float(190)
        bottomY = baseY - Float(270)
        
        self.vertexArray += [
            ShaderVertex(
                position: vector_float2(leftX, topY), color: vector_float4(0, 0, 1, 1)
            ),
            ShaderVertex(
                position: vector_float2(leftX, bottomY), color: vector_float4(0, 0, 1, 1)
            ),
            ShaderVertex(
                position: vector_float2(rightX, bottomY),  color: vector_float4(0, 0, 1, 1)
            ),
            
            ShaderVertex(
                position: vector_float2(leftX, topY), color: vector_float4(0, 0, 1, 1)
            ),
            ShaderVertex(
                position: vector_float2(rightX, topY), color: vector_float4(0, 0, 1, 1)
            ),
            ShaderVertex(
                position: vector_float2(rightX, bottomY),  color: vector_float4(0, 0, 1, 1)
            )
        ]
        
        
        
        /**
         2. 描画先が不透明で、描画元が透過度をもつ場合
           -> アルファブレンディングされること
         */
        // 不透明な赤い長方形
        // -> clearColor の上に塗る
        leftX = Float(20) - baseX
        rightX = Float(100) - baseX
        topY = baseY - Float(300)
        bottomY = baseY - Float(380)

        self.vertexArray += [
            ShaderVertex(
                position: vector_float2(leftX, topY), color: vector_float4(1, 0, 0, 1)
            ),
            ShaderVertex(
                position: vector_float2(leftX, bottomY), color: vector_float4(1, 0, 0, 1)
            ),
            ShaderVertex(
                position: vector_float2(rightX, bottomY),  color: vector_float4(1, 0, 0, 1)
            ),
            
            ShaderVertex(
                position: vector_float2(leftX, topY), color: vector_float4(1, 0, 0, 1)
            ),
            ShaderVertex(
                position: vector_float2(rightX, topY), color: vector_float4(1, 0, 0, 1)
            ),
            ShaderVertex(
                position: vector_float2(rightX, bottomY),  color: vector_float4(1, 0, 0, 1)
            )
        ]
        
        // 透明な青い長方形
        // -> 不透明な赤い長方形の上から重ねて塗る
        leftX = Float(30) - baseX
        rightX = Float(110) - baseX
        topY = baseY - Float(310)
        bottomY = baseY - Float(390)
        
        self.vertexArray += [
            ShaderVertex(
                position: vector_float2(leftX, topY), color: vector_float4(0, 0, 1, 0.5)
            ),
            ShaderVertex(
                position: vector_float2(leftX, bottomY), color: vector_float4(0, 0, 1, 0.5)
            ),
            ShaderVertex(
                position: vector_float2(rightX, bottomY),  color: vector_float4(0, 0, 1, 0.5)
            ),
            
            ShaderVertex(
                position: vector_float2(leftX, topY), color: vector_float4(0, 0, 1, 0.5)
            ),
            ShaderVertex(
                position: vector_float2(rightX, topY), color: vector_float4(0, 0, 1, 0.5)
            ),
            ShaderVertex(
                position: vector_float2(rightX, bottomY),  color: vector_float4(0, 0, 1, 0.5)
            )
        ]
        
        
        
        /**
         3. 描画先、描画元が共に透過度を持つ場合
           -> アルファブレンディングされること
         */
        // 透明な赤い長方形
        // -> clearColor の上に塗る
        leftX = Float(20) - baseX
        rightX = Float(100) - baseX
        topY = baseY - Float(400)
        bottomY = baseY - Float(480)

        self.vertexArray += [
            ShaderVertex(
                position: vector_float2(leftX, topY), color: vector_float4(1, 0, 0, 0.5)
            ),
            ShaderVertex(
                position: vector_float2(leftX, bottomY), color: vector_float4(1, 0, 0, 0.5)
            ),
            ShaderVertex(
                position: vector_float2(rightX, bottomY),  color: vector_float4(1, 0, 0, 0.5)
            ),
            
            ShaderVertex(
                position: vector_float2(leftX, topY), color: vector_float4(1, 0, 0, 0.5)
            ),
            ShaderVertex(
                position: vector_float2(rightX, topY), color: vector_float4(1, 0, 0, 0.5)
            ),
            ShaderVertex(
                position: vector_float2(rightX, bottomY),  color: vector_float4(1, 0, 0, 0.5)
            )
        ]
        
        // 透明な青い長方形
        // -> 不透明な赤い長方形の上から重ねて塗る
        leftX = Float(30) - baseX
        rightX = Float(110) - baseX
        topY = baseY - Float(410)
        bottomY = baseY - Float(490)
        
        self.vertexArray += [
            ShaderVertex(
                position: vector_float2(leftX, topY), color: vector_float4(0, 0, 1, 0.5)
            ),
            ShaderVertex(
                position: vector_float2(leftX, bottomY), color: vector_float4(0, 0, 1, 0.5)
            ),
            ShaderVertex(
                position: vector_float2(rightX, bottomY),  color: vector_float4(0, 0, 1, 0.5)
            ),
            
            ShaderVertex(
                position: vector_float2(leftX, topY), color: vector_float4(0, 0, 1, 0.5)
            ),
            ShaderVertex(
                position: vector_float2(rightX, topY), color: vector_float4(0, 0, 1, 0.5)
            ),
            ShaderVertex(
                position: vector_float2(rightX, bottomY),  color: vector_float4(0, 0, 1, 0.5)
            )
        ]
        
        
    }
}
