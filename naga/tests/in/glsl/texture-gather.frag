#version 450
// textureGather/textureGatherOffset, including the optional component (a
// constant expression), array layers, cube maps, integer and depth textures.

layout(set = 0, binding = 0) uniform texture2D tex2d;
layout(set = 0, binding = 1) uniform texture2DArray tex2dArray;
layout(set = 0, binding = 2) uniform textureCube texCube;
layout(set = 0, binding = 3) uniform utexture2D utex2d;
layout(set = 0, binding = 4) uniform texture2D depth2d;
layout(set = 0, binding = 5) uniform texture2DArray depth2dArray;
layout(set = 0, binding = 6) uniform sampler samp;
layout(set = 0, binding = 7) uniform samplerShadow sampShadow;

layout(location = 0) in vec2 uv;
layout(location = 0) out vec4 o;

const int COMPONENT = 2;

void main() {
    vec4 a = textureGather(sampler2D(tex2d, samp), uv);
    vec4 b = textureGather(sampler2D(tex2d, samp), uv, 3);
    vec4 c = textureGather(sampler2D(tex2d, samp), uv, COMPONENT);
    vec4 d = textureGatherOffset(sampler2D(tex2d, samp), uv, ivec2(1, -1));
    vec4 e = textureGatherOffset(sampler2DArray(tex2dArray, samp), vec3(uv, 1.0), ivec2(1, 0), 1);
    vec4 f = textureGather(samplerCube(texCube, samp), vec3(uv, 1.0));
    uvec4 g = textureGather(usampler2D(utex2d, samp), uv, 1);
    vec4 h = textureGather(sampler2DShadow(depth2d, sampShadow), uv, 0.5);
    vec4 i = textureGatherOffset(sampler2DArrayShadow(depth2dArray, sampShadow), vec3(uv, 2.0), 0.5, ivec2(-1, 1));
    o = a + b + c + d + e + f + vec4(g) + h + i;
}
