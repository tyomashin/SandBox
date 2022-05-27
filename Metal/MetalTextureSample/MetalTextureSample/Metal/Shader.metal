//
//  Shader.metal
//  MetalTextureSample
//
//  Created by 岡崎伸也 on 2022/05/09.
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

    // テクスチャ座標
    float2 textureCoordinate;
    
    // テクスチャのアルファ値
    float targetAlpha;

} RasterizerData;

vertex RasterizerData vertexShader(
   uint vertexID [[vertex_id]],
   constant ShaderVertex *vertices
        [[buffer(kShaderVertexInputIndexVertices)]],
   constant vector_float2 *viewportSize
        [[buffer(kShaderVertexInputIndexViewportSize)]])
{
    RasterizerData result = {};
    result.position = float4(0.0, 0.0, 0.0, 1.0);
    result.position.xy = vertices[vertexID].position / (*viewportSize);
    result.color = vertices[vertexID].color;
    result.textureCoordinate = vertices[vertexID].textureCoordinate;
    result.targetAlpha = vertices[vertexID].targetAlpha;
    return result;
}

/**
 参考
 ・Creating and Sampling Textures
   https://developer.apple.com/documentation/metal/textures/creating_and_sampling_textures
 */
fragment float4 fragmentShader(
    RasterizerData in [[stage_in]],
    metal::texture2d<half> texture [[texture(kFragmentInputIndexTexture)]])
{
    /**
     レンダリングされる領域サイズとテクスチャサイズが異なる場合に、どのように色を補完するかを決める。
     ・mag_filterモードは、領域がテクスチャのサイズより大きいときにサンプラーが返す色を計算する方法を指定
     ・min_filterモードは、領域がテクスチャのサイズより小さいときにサンプラーが返す色を計算する方法を指定
     */
    constexpr metal::sampler textureSampler(metal::mag_filter::nearest,
                                            metal::min_filter::nearest);
    const half4 colorSample = texture.sample(textureSampler,
        in.textureCoordinate);
        
    float4 color = float4(colorSample);
    // アルファチャンネルが0の場合、透明箇所なので色を破棄
    // 参考：https://metalbyexample.com/translucency-and-transparency/
    /*
    if (color.a == 0) {
        discard_fragment();
    } else {
        color.a *= in.targetAlpha;
    }
    */
    color.r *= in.targetAlpha;
    color.g *= in.targetAlpha;
    color.b *= in.targetAlpha;
    color.a *= in.targetAlpha;
    return color;
    
    //return in.color;
}
