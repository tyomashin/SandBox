//
//  ShaderTypes.h
//  MetalSample
//
//  Created by 岡崎伸也 on 2022/04/05.
//

#ifndef ShaderTypes_h
#define ShaderTypes_h

// Objective-C ? のヘッダーファイル定義と同じだと思う。
// 参考：https://qiita.com/masanori-inukai/items/663e23f2390bf52fcffd
// > 「使用したいObjective-CのヘッダーファイルをBridging-Header.hにimportする」
//    と書かれている

// ベクトル演算や行列計算を行うためのもの。
// ここでは「vectore_float2」などを使うのに使用する。
// memo: Appleプラットフォームだと「Accelerate」フレームワークで提供されている。
#include <simd/simd.h>

enum
{
    kShaderVertexInputIndeVertices          = 0,
    kShaderVertexInputIndexViewportSize     = 1,
};

typedef struct
{
    vector_float2 position;
    vector_float4 color;
}

#endif /* ShaderTypes_h */
