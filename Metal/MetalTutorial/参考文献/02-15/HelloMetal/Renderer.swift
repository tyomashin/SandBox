import Foundation
import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    let parent: MetalView
    var commandQueue: MTLCommandQueue?
    var pipelineState: MTLRenderPipelineState?
    var viewportSize: CGSize = CGSize()
    var vertices: [ShaderVertex] = [ShaderVertex]()
    var vertices2: [ShaderVertex] = [ShaderVertex]()
    var device: MTLDevice!
    
    init(_ parent: MetalView) {
        self.parent = parent
    }
    
    func setup(device: MTLDevice, view: MTKView) {
        self.device = device
        self.commandQueue = device.makeCommandQueue()
        setupPipelineState(device: device, view: view)
        
        initData()
    }

    func setupPipelineState(device: MTLDevice, view: MTKView) {
        guard let library = device.makeDefaultLibrary() else {
            return
        }
        
        guard let vertexFunc = library.makeFunction(
                    name: "vertexShader"),
              let fragmentFunc = library.makeFunction(
                    name: "fragmentShader") else {
                return
        }
        
        let pipelineStateDesc = MTLRenderPipelineDescriptor()
        pipelineStateDesc.label = "Triangle Pipeline"
        pipelineStateDesc.vertexFunction = vertexFunc
        pipelineStateDesc.fragmentFunction = fragmentFunc
        pipelineStateDesc.colorAttachments[0].pixelFormat =
            view.colorPixelFormat
        
        do {
            self.pipelineState = try device.makeRenderPipelineState(
                descriptor: pipelineStateDesc)
        } catch let error  {
            print(error)
        }
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.viewportSize = size

        // 三角形の頂点の座標を計算する
        let wh = Float(min(size.width, size.height))
        /*
        self.vertices = [ShaderVertex(position: vector_float2(0.0, wh / 4.0),
                                      color: vector_float4(1.0, 0.0, 0.0, 1.0)),
                         ShaderVertex(position: vector_float2(-wh / 4.0, -wh / 4.0),
                                      color: vector_float4(0.0, 1.0, 0.0, 1.0)),
                         ShaderVertex(position: vector_float2(wh / 4.0, -wh / 4.0),
                                      color: vector_float4(0.0, 0.0, 1.0, 1.0))]
        */
        
        /*
        // サンプル：三角形を二つ足して長方形を描画
        self.vertices = [ShaderVertex(position: vector_float2(-150, 0),
                                      color: vector_float4(1, 0.0, 0.0, 0.5)),
                         ShaderVertex(position: vector_float2(-150, -100),
                                      color: vector_float4(1, 0, 0.0, 0.5)),
                         ShaderVertex(position: vector_float2(150, -100),
                                      color: vector_float4(1, 0.0, 0, 0.5)),
                         
                         ShaderVertex(position: vector_float2(-150, 0),
                                      color: vector_float4(1, 0.0, 0.0, 0.5)),
                         ShaderVertex(position: vector_float2(150, 0),
                                      color: vector_float4(1.0, 0, 0.0, 0.5)),
                         ShaderVertex(position: vector_float2(150, -100),
                                      color: vector_float4(1.0, 0.0, 0, 0.5))
        ]
        */
        
        /*
        self.vertices2 = [ShaderVertex(position: vector_float2(0, 0),
                                       color: vector_float4(0, 0.0, 0.0, 0.5)),
                         ShaderVertex(position: vector_float2(100, 0),
                                      color: vector_float4(0.0, 0, 0.0, 0.5)),
                         ShaderVertex(position: vector_float2(100, -100),
                                      color: vector_float4(0.0, 0.0, 0, 0.5))]
        */
    }
    
    func draw(in view: MTKView) {
        let date = Date()
        guard vertices.count >= 3 else { return }

        guard let cmdBuffer = self.commandQueue?.makeCommandBuffer() else {
            return
        }

        guard let renderPassDesc = view.currentRenderPassDescriptor else {
            return
        }
        
        guard let encoder = cmdBuffer.makeRenderCommandEncoder(
            descriptor: renderPassDesc) else {
            return
        }

        encoder.setViewport(MTLViewport(originX: 0, originY: 0,
                                        width: Double(self.viewportSize.width),
                                        height: Double(self.viewportSize.height),
                                        znear: 0.0, zfar: 1.0))

        if let pipeline = self.pipelineState {
            // パイプライン状態オブジェクトを設定する
            encoder.setRenderPipelineState(pipeline)
            
            // Vertex関数に渡す引数を設定する
            /*
            encoder.setVertexBytes(&self.vertices,
                                   length: MemoryLayout<ShaderVertex>.size *
                                        self.vertices.count,
                                   index: kShaderVertexInputIndexVertices)
            */
            let vertexBuffer = device.makeBuffer(
                bytes: vertices, length: MemoryLayout<ShaderVertex>.size * self.vertices.count, options: []
            )
            encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            
            
            var vpSize = vector_float2(Float(self.viewportSize.width / 2.0),
                                       Float(self.viewportSize.height / 2.0))
            encoder.setVertexBytes(&vpSize,
                                   length: MemoryLayout<vector_float2>.size,
                                   index: kShaderVertexInputIndexViewportSize)
            
            // 三角形を描画する
//            encoder.drawPrimitives(type: .triangle,
//                                   vertexStart: 0, vertexCount: 3)
            
//            encoder.setVertexBytes(self.vertices2,
//                                   length: MemoryLayout<ShaderVertex>.size *
//                                        self.vertices2.count,
//                                   index: kShaderVertexInputIndexVertices)
            
            encoder.drawPrimitives(type: .triangle,
                                   vertexStart: 0, vertexCount: vertices.count)
        }

        encoder.endEncoding()

        if let drawable = view.currentDrawable {
            cmdBuffer.present(drawable)
        }

        cmdBuffer.commit()
        
        print("hoge!!!", Date().timeIntervalSince(date))
    }
}

extension Renderer {
    func initData() {
        var leftX: Float = -300
        var topY: Float = 500
        let date = Date()
        for y in 0..<1000 {
            for x in 0..<10 {
                vertices += [
                    ShaderVertex(position: vector_float2(leftX, topY), color: vector_float4(1.0, 0.0, 0.0, 1.0)),
                    ShaderVertex(position: vector_float2(leftX, topY - 2), color: vector_float4(1.0, 0.0, 0.0, 1.0)),
                    ShaderVertex(position: vector_float2(leftX + 40, topY - 2), color: vector_float4(1.0, 0.0, 0.0, 1.0)),
                    
                    ShaderVertex(position: vector_float2(leftX, topY), color: vector_float4(1.0, 0.0, 0.0, 1.0)),
                    ShaderVertex(position: vector_float2(leftX + 40, topY), color: vector_float4(1.0, 0.0, 0.0, 1.0)),
                    ShaderVertex(position: vector_float2(leftX + 40, topY - 2), color: vector_float4(1.0, 0.0, 0.0, 1.0))
                ]
                leftX += 60
            }
            leftX = -300
            topY -= 5
        }
        
        print("hoge!", Date().timeIntervalSince(date))
    }
    
}
