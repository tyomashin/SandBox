//
//  OpaquePipeLineObjectDrawer.swift
//  MetalBrendhingSample
//
//  Created by 岡崎伸也 on 2022/05/26.
//

import Foundation
import MetalKit

/**
 全て不透明なパイプライン状態オブジェクト描画クラス
 
 ・ブレンディング設定はOFF
 ・描画先（destination）の色に関係なく、常に描画元（source）の色で塗られる
 ・描画元の色にアルファ値がある場合でも、不透明な色が塗られる
     -> 例えばアルファ値が0の場合は、真っ白に描画される（ブレンディングが有効の場合は、描画先の色が表示されるが）
 
 */
class OpaquePipeLineObjectDrawer {
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
        
        // ブレンディングを無効
        pipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = false
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
        var topY = baseY - Float(20)
        var bottomY = baseY - Float(100)
        
        // 赤い長方形
        // -> clearColor の上に塗る
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
        
        // 青い長方形
        // -> 赤い長方形の上から重ねて塗る
        leftX = Float(30) - baseX
        rightX = Float(110) - baseX
        topY = baseY - Float(30)
        bottomY = baseY - Float(110)
        
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

        // 補足：アルファ値を持った場合
        // -> ブレンディングは無効なので、透過しない（真っ白になる）
        leftX = Float(40) - baseX
        rightX = Float(120) - baseX
        topY = baseY - Float(40)
        bottomY = baseY - Float(120)
        
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
