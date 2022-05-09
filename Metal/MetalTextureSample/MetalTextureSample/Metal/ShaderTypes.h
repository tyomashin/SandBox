//
//  ShaderTypes.h
//  MetalTextureSample
//
//  Created by 岡崎伸也 on 2022/05/09.
//

#ifndef SHADER_TYPES_H
#define SHADER_TYPES_H

#include <simd/simd.h>

enum
{
    kShaderVertexInputIndexVertices       = 0,
    kShaderVertexInputIndexViewportSize   = 1,
};

enum
{
    kFragmentInputIndexTexture = 0
};

typedef struct
{
    vector_float2 position;
    vector_float4 color;
    vector_float2 textureCoordinate;

} ShaderVertex;

#endif /* SHADER_TYPES_H */
