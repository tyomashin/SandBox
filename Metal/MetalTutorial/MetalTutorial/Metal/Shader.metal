//
//  Shader.metal
//  MetalTutorial
//
//  Created by 岡崎伸也 on 2022/04/30.
//

#include <metal_stdlib>
using namespace metal;


/// 頂点の座標と、ViewPortのサイズを引数に取る
vertex float4 basic_vertex(
    const device packed_float3* vertex_array [[ buffer(0) ]],
    const device vector_float2* viewport_size [[ buffer(1) ]],
    unsigned int vid [[ vertex_id ]])
{
    // return float4(vertex_array[vid], 1.0);
    
    // memo: ViewPort は通常「左下：(-1, -1), 右上：(1, 1)」という正規化された座標になる。
    // memo: 引数で実際のデバイス座標を受け取る場合は、Vertex関数側で正規化する必要がある
    float4 result = float4(0,0,0,1.0);
    result.xy = vertex_array[vid].xy / (*viewport_size);
    return result;
}

/// memo: ここでは、Fragment関数の引数は指定していないが、ここには本来Vertex関数の戻り値が入ってくる
// 例：書籍の例
// -> fragment float4 fragmentShader(RasterizerData in [[stage_in]]) {  }
// RasterizerDataは、Vertex関数の戻り値. 「stage_in」は、このFragmentステージに渡されるデータを意味すると思われる

fragment half4 basic_fragment() {
    return half4(1.0);
}
