//
//  ShaderTypes.h
//  ManyRectangleMetalSample
//
//  Created by 岡崎伸也 on 2022/05/03.
//

#ifndef SHADER_TYPES_H
#define SHADER_TYPES_H

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
    float cornerRadius;
    vector_float2 center;
    vector_float2 rectSize;
    
} ShaderVertex;

#endif /* ShaderTypes_h */
