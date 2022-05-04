//
//  Shader.metal
//  ManyRectangleMetalSample
//
//  Created by 岡崎伸也 on 2022/05/03.
//

#include <metal_stdlib>
using namespace metal;

#include "ShaderTypes.h"

/* Vertex関数が出力するデータの型定義
 
 [[position]] で指定したプロパティは、Metalに対してそのデータが位置データであることを示す。
 他のプロパティは、Rasterizationステージによって、頂点間のピクセル位置によって補完された値が入る。
 
 */
typedef struct {
    // -1.0〜1.0に正規化した座標
    // -> metalに対してこの頂点の位置データであることを示す
    float4 position [[position]];
    // 色. Vertexステージを抜けた後は、Metalが自動計算した補正値が入る
    // （頂点間で色が同じ場合は１色だが、頂点間で色が違う場合は自動でグラデーションがかけられた色になる）
    float4 color;
    
    /* 内部計算用
     memo: この値もMetalによって自動で頂点間で補正された値が入る。
     */
    // 正規化する前の座標
    float2 appPosition;
    // 角丸半径
    float cornerRadius;
    // 長方形の中心
    float2 center;
    // 長方形の中心から短辺までの距離
    float2 rectSize;
    
    /* 定数を定義する場合
     memo: この値はMetalによって再代入されない
     */
    const float4 constColor = float4(0,1,0,1);
    
} RasterizerData;


/* 関数を定義 */

// 角丸を実現するために、長方形の中心からあるピクセル座標までの距離を求める
// memo: 0よりも大きい場合は角丸長方形の範囲外
// 参考：https://github.com/warpdotdev/samples/blob/main/how-to-draw-rectangles-using-gpu.metal
// https://www.warp.dev/blog/how-to-draw-styled-rectangles-using-the-gpu-and-metal
// https://blog.narumium.net/2020/11/05/%E3%80%90glsl%E3%80%91%E5%9B%9B%E8%A7%92%E5%BD%A2%E3%82%92%E6%8F%8F%E3%81%8F/
float distance_from_rect(vector_float2 pixel_pos, vector_float2 rect_center, vector_float2 rect_corner, float corner_radius) {
    vector_float2 p = pixel_pos - rect_center;
    vector_float2 q = abs(p) - rect_corner + corner_radius;
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - corner_radius;
}

/* 長方形を描画するシェーダー関数を定義 */

vertex RasterizerData vertexShader
(
 uint vertexID [[vertex_id]],
 constant ShaderVertex *vertices [[buffer(kShaderVertexInputIndeVertices)]],
 constant vector_float2 *viewportSize [[buffer(kShaderVertexInputIndexViewportSize)]])
{
    RasterizerData result = {};
    result.position = float4(0.0, 0.0, 0.0, 1.0);
    result.position.xy = vertices[vertexID].position / (*viewportSize);
    result.color = vertices[vertexID].color;
    
    result.appPosition = vertices[vertexID].position.xy;
    result.cornerRadius = vertices[vertexID].cornerRadius;
    result.center = vertices[vertexID].center;
    result.rectSize = vertices[vertexID].rectSize;
    return result;
}

fragment float4 fragmentShader(RasterizerData in [[stage_in]])
{
    // Metalが計算したピクセルの色
    float4 color = in.color;
    
    /* 角丸にする処理 */
    float distance = distance_from_rect(in.appPosition, in.center, in.rectSize, in.cornerRadius);
    // 角丸長方形の範囲外のピクセルは透明にする
    // memo: アンチエイリアス：ギザギザにならないように対応している
    color.a *= 1.0 - smoothstep(-0.75, -0.1, distance);
     // memo: 以下の書き方だとギザギザになる
    /*
    if (in.cornerRadius > 0 && distance > 0) {
        color.a = 0.0;
    }
    */
    
    return color;
}
