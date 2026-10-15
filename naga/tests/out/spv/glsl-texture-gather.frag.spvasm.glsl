#version 460

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

layout(location = 0) in vec2 _161;
layout(location = 0) out vec4 _164;
vec2 _35 = vec2(0.0);
vec4 _38 = vec4(0.0);

void _42()
{
    uvec4 _74 = uvec4(0u);
    vec4 _68 = vec4(0.0);
    vec4 _61 = vec4(0.0);
    vec4 _77 = vec4(0.0);
    vec4 _70 = vec4(0.0);
    vec4 _64 = vec4(0.0);
    vec4 _79 = vec4(0.0);
    vec4 _72 = vec4(0.0);
    vec4 _66 = vec4(0.0);
    _61 = textureGather(sampler2D(_20, _32), _35);
    _64 = textureGather(sampler2D(_20, _32), _35, int(3u));
    _66 = textureGather(sampler2D(_20, _32), _35, int(2u));
    _68 = textureGatherOffset(sampler2D(_20, _32), _35, ivec2(1, -1));
    vec3 _101 = vec3(_35, 1.0);
    _70 = textureGatherOffset(sampler2DArray(_22, _32), vec3(_101.xy, float(int(clamp(_101.z, -2147483648.0, 2147483520.0)))), ivec2(1, 0), int(1u));
    _72 = textureGather(samplerCube(_24, _32), vec3(_35, 1.0));
    _74 = textureGather(usampler2D(_26, _32), _35, int(1u));
    _77 = textureGather(sampler2DShadow(_28, _34), _35, 0.5);
    vec3 _132 = vec3(_35, 2.0);
    vec3 _139 = vec3(_132.xy, float(int(clamp(_132.z, -2147483648.0, 2147483520.0))));
    _79 = textureGatherOffset(sampler2DArrayShadow(_30, _34), _139, 0.5, ivec2(-1, 1));
    _38 = (((((((_61 + _64) + _66) + _68) + _70) + _72) + vec4(_74)) + _77) + _79;
}

void main()
{
    _35 = _161;
    _42();
    _164 = _18(_38)._m0;
}

