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
    thread metal::int2& offset_1,
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
    metal::float4 j = {};
    metal::float4 k = {};
    metal::uint4 l = {};
    metal::float4 m = {};
    metal::float4 n = {};
    metal::float2 _e11 = uv_1;
    metal::float4 _e12 = tex2d.gather(samp, _e11);
    a = _e12;
    metal::float2 _e14 = uv_1;
    metal::float4 _e15 = tex2d.gather(samp, _e14, metal::int2(0), metal::component::w);
    b = _e15;
    metal::float2 _e17 = uv_1;
    metal::float4 _e18 = tex2d.gather(samp, _e17, metal::int2(0), metal::component::z);
    c = _e18;
    metal::float2 _e20 = uv_1;
    metal::float4 _e24 = tex2d.gather(samp, _e20, metal::int2(1, -1));
    d = _e24;
    metal::float2 _e26 = uv_1;
    metal::float3 _e30 = metal::float3(_e26.x, _e26.y, 1.0);
    metal::float4 _e40 = tex2dArray.gather(samp, _e30.xy, naga_f2i32(metal::floor(_e30.z + 0.5)), metal::int2(1, 0), metal::component::y);
    e = _e40;
    metal::float2 _e42 = uv_1;
    metal::float4 _e47 = texCube.gather(samp, metal::float3(_e42.x, _e42.y, 1.0));
    f = _e47;
    metal::float2 _e49 = uv_1;
    metal::uint4 _e50 = utex2d.gather(samp, _e49, metal::int2(0), metal::component::y);
    g = _e50;
    metal::float2 _e52 = uv_1;
    metal::float4 _e54 = depth2d.gather_compare(sampShadow, _e52, 0.5);
    h = _e54;
    metal::float2 _e56 = uv_1;
    metal::float3 _e60 = metal::float3(_e56.x, _e56.y, 2.0);
    metal::float4 _e71 = depth2dArray.gather_compare(sampShadow, _e60.xy, naga_f2i32(metal::floor(_e60.z + 0.5)), 0.5, metal::int2(-1, 1));
    i = _e71;
    metal::float2 _e73 = uv_1;
    metal::int2 _e74 = offset_1;
    metal::float4 _e81 = tex2d.gather(samp, _e73 + (static_cast<metal::float2>(_e74) / static_cast<metal::float2>(metal::uint2(tex2d.get_width(0), tex2d.get_height(0)))), metal::int2(0), metal::component::z);
    j = _e81;
    metal::float2 _e83 = uv_1;
    metal::float3 _e87 = metal::float3(_e83.x, _e83.y, 1.75);
    metal::int2 _e88 = offset_1;
    metal::float4 _e101 = tex2dArray.gather(samp, _e87.xy + (static_cast<metal::float2>(_e88) / static_cast<metal::float2>(metal::uint2(tex2dArray.get_width(0), tex2dArray.get_height(0)))), naga_f2i32(metal::floor(_e87.z + 0.5)));
    k = _e101;
    metal::float2 _e103 = uv_1;
    metal::int2 _e104 = offset_1;
    metal::uint4 _e111 = utex2d.gather(samp, _e103 + (static_cast<metal::float2>(_e104) / static_cast<metal::float2>(metal::uint2(utex2d.get_width(0), utex2d.get_height(0)))));
    l = _e111;
    metal::float2 _e113 = uv_1;
    metal::int2 _e115 = offset_1;
    metal::float4 _e122 = depth2d.gather_compare(sampShadow, _e113 + (static_cast<metal::float2>(_e115) / static_cast<metal::float2>(metal::uint2(depth2d.get_width(0), depth2d.get_height(0)))), 0.5);
    m = _e122;
    metal::float2 _e124 = uv_1;
    metal::float3 _e128 = metal::float3(_e124.x, _e124.y, 2.5);
    metal::int2 _e130 = offset_1;
    metal::float4 _e143 = depth2dArray.gather_compare(sampShadow, _e128.xy + (static_cast<metal::float2>(_e130) / static_cast<metal::float2>(metal::uint2(depth2dArray.get_width(0), depth2dArray.get_height(0)))), naga_f2i32(metal::floor(_e128.z + 0.5)), 0.5);
    n = _e143;
    metal::float4 _e145 = a;
    metal::float4 _e146 = b;
    metal::float4 _e148 = c;
    metal::float4 _e150 = d;
    metal::float4 _e152 = e;
    metal::float4 _e154 = f;
    metal::uint4 _e156 = g;
    metal::float4 _e159 = h;
    metal::float4 _e161 = i;
    metal::float4 _e163 = j;
    metal::float4 _e165 = k;
    metal::uint4 _e167 = l;
    metal::float4 _e170 = m;
    metal::float4 _e172 = n;
    o = ((((((((((((_e145 + _e146) + _e148) + _e150) + _e152) + _e154) + static_cast<metal::float4>(_e156)) + _e159) + _e161) + _e163) + _e165) + static_cast<metal::float4>(_e167)) + _e170) + _e172;
    return;
}

struct main_Input {
    metal::float2 uv [[user(loc0), center_perspective]];
    metal::int2 offset [[user(loc1), flat]];
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
    metal::int2 offset_1 = {};
    metal::float4 o = {};
    const auto uv = varyings.uv;
    const auto offset = varyings.offset;
    uv_1 = uv;
    offset_1 = offset;
    main_1(tex2d, tex2dArray, texCube, utex2d, depth2d, depth2dArray, samp, sampShadow, uv_1, offset_1, o);
    metal::float4 _e5 = o;
    const auto _tmp = FragmentOutput {_e5};
    return main_Output { _tmp.o };
}
