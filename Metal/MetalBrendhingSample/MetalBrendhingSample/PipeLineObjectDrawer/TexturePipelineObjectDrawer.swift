//
//  TexturePipelineObjectDrawer.swift
//  MetalBrendhingSample
//
//  Created by 岡崎伸也 on 2022/06/29.
//

import Foundation
import MetalKit

/// テクスチャを描画するパイプライン状態オブジェクト
class TexturePipelineObjectDrawer {
    var device: MTLDevice!
    // GPUで処理するレンダーパイプラインの状態オブジェクト
    var pipelineState: MTLRenderPipelineState!
   
    // サンプルの描画データ
    var vertexArray = [ShaderVertexForTexture]()
    // テクスチャ
    var texture: MTLTexture!
    
   /// パイプライン状態オブジェクトを初期化する
   func setupPSO(currentDevice: MTLDevice, library: MTLLibrary) {
       self.device = currentDevice
       // シェーダー間数オブジェクトを取得
       let vertexProgram = library.makeFunction(name: "vertexShaderForTexture")
       let fragmentProgram = library.makeFunction(name: "fragmentShaderForAlphaBlending")
       
       // PSOのデスクリプタを定義
       let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
       pipelineStateDescriptor.label = "TexturePipelineObjectDrawer"
       pipelineStateDescriptor.vertexFunction = vertexProgram
       pipelineStateDescriptor.fragmentFunction = fragmentProgram
       pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
              
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
       let vertexBuffer = currentDevice.makeBuffer(bytes: vertexArray, length: MemoryLayout<ShaderVertexForTexture>.size * vertexArray.count, options: [])
       // 描画情報をVertex関数の引数に渡す
       encoder.setVertexBuffer(vertexBuffer, offset: 0, index: kShaderVertexInputIndexVertices)
       // ViewPortのサイズをVertex関数に渡す
       var vpSize = vector_float2(Float(view.frame.width / 2), Float(view.frame.height / 2))
       encoder.setVertexBytes(&vpSize, length: MemoryLayout<vector_float2>.size, index: kShaderVertexInputIndexViewportSize)
       
       // テクスチャを設定する
       encoder.setFragmentTexture(self.texture, index: kFragmentInputIndexTexture)
       
       // 描画コマンド実行
       encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexArray.count)
   }
   
   func initData(view: UIView) {
       let baseX: Float = Float(view.frame.width / 2)
       let baseY: Float = Float(view.frame.height / 2)
       
       var leftX = Float(20) - baseX
       var rightX = Float(120) - baseX
       var topY = baseY - Float(100)
       var bottomY = baseY - Float(200)
       
       // 赤い長方形
       // -> clearColor の上に塗る
       self.vertexArray += [
           ShaderVertexForTexture(
               position: vector_float2(leftX, topY), color: vector_float4(1, 0, 0, 1), textureCoordinate: vector_float2(0.0, 0.0), targetAlpha: 1
           ),
           ShaderVertexForTexture(
               position: vector_float2(leftX, bottomY), color: vector_float4(1, 0, 0, 1), textureCoordinate: vector_float2(0.0, 1.0), targetAlpha: 1
           ),
           ShaderVertexForTexture(
               position: vector_float2(rightX, bottomY),  color: vector_float4(1, 0, 0, 1), textureCoordinate: vector_float2(1.0, 1.0), targetAlpha: 1
           ),
           
           ShaderVertexForTexture(
               position: vector_float2(leftX, topY), color: vector_float4(1, 0, 0, 1), textureCoordinate: vector_float2(0.0, 0.0), targetAlpha: 1
           ),
           ShaderVertexForTexture(
               position: vector_float2(rightX, topY), color: vector_float4(1, 0, 0, 1), textureCoordinate: vector_float2(1.0, 0.0), targetAlpha: 1
           ),
           ShaderVertexForTexture(
               position: vector_float2(rightX, bottomY),  color: vector_float4(1, 0, 0, 1), textureCoordinate: vector_float2(1.0, 1.0), targetAlpha: 1
           )
       ]
       
       // テクスチャ生成
       let textCreater = TextImageCreater()
       let textureCreater = TextureCreator()
       let image = textCreater.makeTextImage()
       texture = textureCreater.makeTextureFromCGImage(device: device, cgImage: image.cgImage!)
   }
}
