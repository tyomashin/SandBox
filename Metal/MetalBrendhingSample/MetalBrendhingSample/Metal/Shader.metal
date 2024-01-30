//
//  Shader.metal
//  MetalBrendhingSample
//
//  Created by 岡崎伸也 on 2022/05/26.
//

#include <metal_stdlib>
#include "ShaderTypes.h"

using namespace metal;

/* 通常の長方形描画用 */

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

// -----------------------------------------------------
/* テクスチャ描画用 */

// アルファテストの閾値
constant float kAlphaTestReferenceValue = 0.8;

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

} RasterizerDataForTexture;

vertex RasterizerDataForTexture vertexShaderForTexture(
   uint vertexID [[vertex_id]],
   constant ShaderVertexForTexture *vertices [[buffer(kShaderVertexInputIndexVertices)]],
   constant vector_float2 *viewportSize [[buffer(kShaderVertexInputIndexViewportSize)]])
{
    RasterizerDataForTexture result = {};
    result.position = float4(0.0, 0.0, 0.0, 1.0);
    result.position.xy = vertices[vertexID].position / (*viewportSize);
    result.color = vertices[vertexID].color;
    result.textureCoordinate = vertices[vertexID].textureCoordinate;
    result.targetAlpha = vertices[vertexID].targetAlpha;
    return result;
}

/**
 テクスチャ描画するためのフラグメントシェーダー

 ・アルファブレンディング
 
 参考
 ・Creating and Sampling Textures
   https://developer.apple.com/documentation/metal/textures/creating_and_sampling_textures
 */
fragment float4 fragmentShaderForAlphaBlending(
    RasterizerDataForTexture in [[stage_in]],
    metal::texture2d<half> texture [[texture(kFragmentInputIndexTexture)]])
{
    /**
     テクスチャ内をサンプリングして色を計算する。
     
     レンダリングされる領域サイズとテクスチャサイズが異なる場合に、どのように色を補完するかを決める。
     ・mag_filterモードは、領域がテクスチャのサイズより大きいときにサンプラーが返す色を計算する方法を指定
     ・min_filterモードは、領域がテクスチャのサイズより小さいときにサンプラーが返す色を計算する方法を指定
     */
    constexpr metal::sampler textureSampler(metal::mag_filter::nearest,
                                            metal::min_filter::nearest);
    const half4 colorSample = texture.sample(textureSampler,
        in.textureCoordinate);
        
    float4 color = float4(colorSample);
    color.r *= in.targetAlpha;
    color.g *= in.targetAlpha;
    color.b *= in.targetAlpha;
    color.a *= in.targetAlpha;
    return color;
    
    //return in.color;
}

/**
 テクスチャ描画するためのフラグメントシェーダー

 ・アルファテスト
   - Pipeline状態オブジェクトのブレンディング設定はオフにしておく
 
 参考
 ・https://metalbyexample.com/translucency-and-transparency/
 */
fragment float4 fragmentShaderForAlphaTest(
    RasterizerDataForTexture in [[stage_in]],
    metal::texture2d<half> texture [[texture(kFragmentInputIndexTexture)]])
{
    /**
     テクスチャ内をサンプリングして色を計算する。
     
     レンダリングされる領域サイズとテクスチャサイズが異なる場合に、どのように色を補完するかを決める。
     ・mag_filterモードは、領域がテクスチャのサイズより大きいときにサンプラーが返す色を計算する方法を指定
     ・min_filterモードは、領域がテクスチャのサイズより小さいときにサンプラーが返す色を計算する方法を指定
     */
    constexpr metal::sampler textureSampler(metal::mag_filter::nearest, metal::min_filter::nearest);
    const half4 colorSample = texture.sample(textureSampler, in.textureCoordinate);
        
    float4 color = float4(colorSample);
    // アルファテスト
    // アルファチャンネルが閾値以下の場合、透明箇所として色を破棄
    // 参考：https://metalbyexample.com/translucency-and-transparency/
    if (color.a < kAlphaTestReferenceValue) {
        discard_fragment();
    }
    
    color.r *= in.targetAlpha;
    color.g *= in.targetAlpha;
    color.b *= in.targetAlpha;
    color.a *= in.targetAlpha;
    return color;
}
