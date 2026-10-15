// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct FragmentOutput {
    metal::float4 o;
};
constant int COMPONENT = 2;

int naga_f2i32(float value) {
    return static_cast<int>(metal::clamp(value, -2147483600.0, 2147483500.0));
}

void main_1(
    metal::texture2d<float, metal::access::sample> tex2d,
    metal::texture2d_array<float, metal::access::sample> tex2dArray,
    metal::texturecube<float, metal::access::sample> texCube,
    metal::texture2d<uint, metal::access::sample> utex2d,
    metal::depth2d<float, metal::access::sample> depth2d,
    metal::depth2d_array<float, metal::access::sample> depth2dArray,
    metal::sampler samp,
    metal::sampler sampShadow,
    thread metal::float2& uv_1,
    thread metal::float4& o
) {
    metal::float4 a = {};
    metal::float4 b = {};
    metal::float4 c = {};
    metal::float4 d = {};
    metal::float4 e = {};
    metal::float4 f = {};
    metal::uint4 g = {};
    metal::float4 h = {};
    metal::float4 i = {};
    metal::float2 _e10 = uv_1;
    metal::float4 _e11 = tex2d.gather(samp, _e10);
    a = _e11;
    metal::float2 _e13 = uv_1;
    metal::float4 _e14 = tex2d.gather(samp, _e13, metal::int2(0), metal::component::w);
    b = _e14;
    metal::float2 _e16 = uv_1;
    metal::float4 _e17 = tex2d.gather(samp, _e16, metal::int2(0), metal::component::z);
    c = _e17;
    metal::float2 _e19 = uv_1;
    metal::float4 _e23 = tex2d.gather(samp, _e19, metal::int2(1, -1));
    d = _e23;
    metal::float2 _e25 = uv_1;
    metal::float3 _e29 = metal::float3(_e25.x, _e25.y, 1.0);
    metal::float4 _e36 = tex2dArray.gather(samp, _e29.xy, naga_f2i32(_e29.z), metal::int2(1, 0), metal::component::y);
    e = _e36;
    metal::float2 _e38 = uv_1;
    metal::float4 _e43 = texCube.gather(samp, metal::float3(_e38.x, _e38.y, 1.0));
    f = _e43;
    metal::float2 _e45 = uv_1;
    metal::uint4 _e46 = utex2d.gather(samp, _e45, metal::int2(0), metal::component::y);
    g = _e46;
    metal::float2 _e48 = uv_1;
    metal::float4 _e50 = depth2d.gather_compare(sampShadow, _e48, 0.5);
    h = _e50;
    metal::float2 _e52 = uv_1;
    metal::float3 _e56 = metal::float3(_e52.x, _e52.y, 2.0);
    metal::float4 _e64 = depth2dArray.gather_compare(sampShadow, _e56.xy, naga_f2i32(_e56.z), 0.5, metal::int2(-1, 1));
    i = _e64;
    metal::float4 _e66 = a;
    metal::float4 _e67 = b;
    metal::float4 _e69 = c;
    metal::float4 _e71 = d;
    metal::float4 _e73 = e;
    metal::float4 _e75 = f;
    metal::uint4 _e77 = g;
    metal::float4 _e80 = h;
    metal::float4 _e82 = i;
    o = (((((((_e66 + _e67) + _e69) + _e71) + _e73) + _e75) + static_cast<metal::float4>(_e77)) + _e80) + _e82;
    return;
}

struct main_Input {
    metal::float2 uv [[user(loc0), center_perspective]];
};
struct main_Output {
    metal::float4 o [[color(0)]];
};
fragment main_Output main_(
  main_Input varyings [[stage_in]]
, metal::texture2d<float, metal::access::sample> tex2d [[user(fake0)]]
, metal::texture2d_array<float, metal::access::sample> tex2dArray [[user(fake0)]]
, metal::texturecube<float, metal::access::sample> texCube [[user(fake0)]]
, metal::texture2d<uint, metal::access::sample> utex2d [[user(fake0)]]
, metal::depth2d<float, metal::access::sample> depth2d [[user(fake0)]]
, metal::depth2d_array<float, metal::access::sample> depth2dArray [[user(fake0)]]
, metal::sampler samp [[user(fake0)]]
, metal::sampler sampShadow [[user(fake0)]]
) {
    metal::float2 uv_1 = {};
    metal::float4 o = {};
    const auto uv = varyings.uv;
    uv_1 = uv;
    main_1(tex2d, tex2dArray, texCube, utex2d, depth2d, depth2dArray, samp, sampShadow, uv_1, o);
    metal::float4 _e3 = o;
    const auto _tmp = FragmentOutput {_e3};
    return main_Output { _tmp.o };
}
