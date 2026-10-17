#version 460
#extension GL_EXT_samplerless_texture_functions : require

struct _18
{
    vec4 _m0;
};

layout(set = 0, binding = 0) uniform texture2D _20;
layout(set = 0, binding = 1) uniform texture2DArray _22;
layout(set = 0, binding = 2) uniform textureCube _24;
layout(set = 0, binding = 3) uniform utexture2D _26;
layout(set = 0, binding = 4) uniform texture2D _28;
layout(set = 0, binding = 5) uniform texture2DArray _30;
layout(set = 0, binding = 6) uniform sampler _32;
layout(set = 0, binding = 7) uniform samplerShadow _34;

layout(location = 0) in vec2 _262;
layout(location = 1) flat in ivec2 _265;
layout(location = 0) out vec4 _268;
vec2 _35 = vec2(0.0);
ivec2 _38 = ivec2(0);
vec4 _41 = vec4(0.0);

void _45()
{
    vec4 _92 = vec4(0.0);
    vec4 _86 = vec4(0.0);
    uvec4 _79 = uvec4(0u);
    vec4 _73 = vec4(0.0);
    vec4 _66 = vec4(0.0);
    vec4 _94 = vec4(0.0);
    vec4 _88 = vec4(0.0);
    vec4 _82 = vec4(0.0);
    vec4 _75 = vec4(0.0);
    vec4 _69 = vec4(0.0);
    uvec4 _90 = uvec4(0u);
    vec4 _84 = vec4(0.0);
    vec4 _77 = vec4(0.0);
    vec4 _71 = vec4(0.0);
    _66 = textureGather(sampler2D(_20, _32), _35);
    _69 = textureGather(sampler2D(_20, _32), _35, int(3u));
    _71 = textureGather(sampler2D(_20, _32), _35, int(2u));
    _73 = textureGatherOffset(sampler2D(_20, _32), _35, ivec2(1, -1));
    vec3 _116 = vec3(_35, 1.0);
    _75 = textureGatherOffset(sampler2DArray(_22, _32), vec3(_116.xy, float(int(clamp(floor(_116.z + 0.5), -2147483648.0, 2147483520.0)))), ivec2(1, 0), int(1u));
    _77 = textureGather(samplerCube(_24, _32), vec3(_35, 1.0));
    _79 = textureGather(usampler2D(_26, _32), _35, int(1u));
    _82 = textureGather(sampler2DShadow(_28, _34), _35, 0.5);
    vec3 _149 = vec3(_35, 2.0);
    vec3 _158 = vec3(_149.xy, float(int(clamp(floor(_149.z + 0.5), -2147483648.0, 2147483520.0))));
    _84 = textureGatherOffset(sampler2DArrayShadow(_30, _34), _158, 0.5, ivec2(-1, 1));
    _86 = textureGather(sampler2D(_20, _32), _35 + (vec2(_38) / vec2(uvec2(textureSize(_20, 0)))), int(2u));
    vec3 _174 = vec3(_35, 1.75);
    _88 = textureGather(sampler2DArray(_22, _32), vec3(_174.xy + (vec2(_38) / vec2(uvec3(textureSize(_22, 0)).xy)), float(int(clamp(floor(_174.z + 0.5), -2147483648.0, 2147483520.0)))));
    _90 = textureGather(usampler2D(_26, _32), _35 + (vec2(_38) / vec2(uvec2(textureSize(_26, 0)))));
    vec2 _208 = _35 + (vec2(_38) / vec2(uvec2(textureSize(_28, 0))));
    _92 = textureGather(sampler2DShadow(_28, _34), _208, 0.5);
    vec3 _214 = vec3(_35, 2.5);
    vec3 _229 = vec3(_214.xy + (vec2(_38) / vec2(uvec3(textureSize(_30, 0)).xy)), float(int(clamp(floor(_214.z + 0.5), -2147483648.0, 2147483520.0))));
    _94 = textureGather(sampler2DArrayShadow(_30, _34), _229, 0.5);
    _41 = ((((((((((((_66 + _69) + _71) + _73) + _75) + _77) + vec4(_79)) + _82) + _84) + _86) + _88) + vec4(_90)) + _92) + _94;
}

void main()
{
    _35 = _262;
    _38 = _265;
    _45();
    _268 = _18(_41)._m0;
}

