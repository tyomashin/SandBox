//
//  ShaderTypes.h
//  MetalBrendhingSample
//
//  Created by 岡崎伸也 on 2022/05/26.
//

#ifndef SHADER_TYPES_H
#define SHADER_TYPES_H

#include <simd/simd.h>

/* 通常の長方形描画用の定義 */

enum
{
    kShaderVertexInputIndexVertices       = 0,
    kShaderVertexInputIndexViewportSize   = 1,
};

typedef struct
{
    vector_float2 position;
    vector_float4 color;

} ShaderVertex;

// --------------------------------
/* テクスチャ描画用の定義 */

enum
{
    kFragmentInputIndexTexture = 0
};

typedef struct
{
    vector_float2 position;
    vector_float4 color;
    vector_float2 textureCoordinate;
    float targetAlpha;

} ShaderVertexForTexture;

#endif /* SHADER_TYPES_H */
