//
//  Shader.metal
//  MetalBrendhingSample
//
//  Created by 岡崎伸也 on 2022/05/26.
//

#include <metal_stdlib>
#include "ShaderTypes.h"

using namespace metal;

// Vertex関数が出力するデータの型定義
typedef struct {
    // 座標
    float4 position [[position]];
    // 色
    float4 color;

} RasterizerData;


// Vertex関数
vertex RasterizerData vertexShader(
   uint vertexID [[vertex_id]],
   constant ShaderVertex *vertices [[buffer(kShaderVertexInputIndexVertices)]],
   constant vector_float2 *viewportSize [[buffer(kShaderVertexInputIndexViewportSize)]])
{
    RasterizerData result = {};
    result.position = float4(0.0, 0.0, 0.0, 1.0);
    result.position.xy = vertices[vertexID].position / (*viewportSize);
    result.color = vertices[vertexID].color;
    return result;
}

// Fragment関数
fragment float4 fragmentShader(
    RasterizerData in [[stage_in]]
)
{
    return in.color;
}
