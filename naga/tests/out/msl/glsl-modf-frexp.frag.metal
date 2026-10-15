// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct _modf_result_f32_ {
    float fract;
    float whole;
};
struct _modf_result_vec3_f32_ {
    metal::packed_float3 fract;
    metal::packed_float3 whole;
};
struct _frexp_result_f32_ {
    float fract;
    int exp;
};
struct _frexp_result_vec2_f32_ {
    metal::float2 fract;
    metal::int2 exp;
};
struct _modf_result_vec2_f32_ {
    metal::float2 fract;
    metal::float2 whole;
};
struct FragmentOutput {
    metal::float4 o;
};

_modf_result_f32_ naga_modf(float arg) {
    float other;
    float fract = metal::modf(arg, other);
    return _modf_result_f32_{ fract, other };
}

_modf_result_vec3_f32_ naga_modf(metal::float3 arg) {
    metal::float3 other;
    metal::float3 fract = metal::modf(arg, other);
    return _modf_result_vec3_f32_{ fract, other };
}

_frexp_result_f32_ naga_frexp(float arg) {
    int other;
    float fract = metal::frexp(arg, other);
    return _frexp_result_f32_{ fract, other };
}

_frexp_result_vec2_f32_ naga_frexp(metal::float2 arg) {
    int2 other;
    metal::float2 fract = metal::frexp(arg, other);
    return _frexp_result_vec2_f32_{ fract, other };
}

_modf_result_vec2_f32_ naga_modf(metal::float2 arg) {
    metal::float2 other;
    metal::float2 fract = metal::modf(arg, other);
    return _modf_result_vec2_f32_{ fract, other };
}

void main_1(
    thread metal::float4& v_1,
    thread metal::float4& o,
    thread metal::float2& global_whole
) {
    float whole = {};
    float fract_part = {};
    metal::float3 whole3_ = {};
    metal::float3 fract3_ = {};
    int e = {};
    float mantissa = {};
    metal::int2 e2_ = {};
    metal::float2 mantissa2_ = {};
    metal::float4 parts = {};
    float local = {};
    metal::float2 local_1 = {};
    metal::float4 _e4 = v_1;
    _modf_result_f32_ _e6 = naga_modf(_e4.x);
    whole = _e6.whole;
    fract_part = _e6.fract;
    metal::float4 _e11 = v_1;
    _modf_result_vec3_f32_ _e13 = naga_modf(_e11.xyz);
    whole3_ = _e13.whole;
    fract3_ = _e13.fract;
    metal::float4 _e18 = v_1;
    _frexp_result_f32_ _e20 = naga_frexp(_e18.w);
    e = _e20.exp;
    mantissa = _e20.fract;
    metal::float4 _e25 = v_1;
    _frexp_result_vec2_f32_ _e27 = naga_frexp(_e25.xy);
    e2_ = _e27.exp;
    mantissa2_ = _e27.fract;
    metal::float4 _e33 = v_1;
    _modf_result_f32_ _e37 = naga_modf(_e33.y);
    local = _e37.whole;
    float _e40 = local;
    parts.y = _e40;
    parts.x = _e37.fract;
    metal::float4 _e41 = v_1;
    _modf_result_vec2_f32_ _e44 = naga_modf(_e41.zw);
    local_1 = _e44.whole;
    metal::float2 _e47 = local_1;
    global_whole = _e47;
    parts.z = _e44.fract.x;
    parts.w = _e44.fract.y;
    float _e52 = fract_part;
    float _e53 = whole;
    metal::float3 _e55 = fract3_;
    metal::float3 _e56 = whole3_;
    metal::float3 _e57 = _e55 + _e56;
    float _e62 = mantissa;
    int _e63 = e;
    metal::float2 _e66 = mantissa2_;
    metal::int2 _e67 = e2_;
    metal::float2 _e69 = _e66 * static_cast<metal::float2>(_e67);
    metal::float4 _e75 = parts;
    metal::float2 _e77 = global_whole;
    o = ((metal::float4(_e52 + _e53, _e57.x, _e57.y, _e57.z) + metal::float4(_e62 * static_cast<float>(_e63), _e69.x, _e69.y, 0.0)) + _e75) + _e77.xyxy;
    return;
}

struct main_Input {
    metal::float4 v [[user(loc0), center_perspective]];
};
struct main_Output {
    metal::float4 o [[color(0)]];
};
fragment main_Output main_(
  main_Input varyings [[stage_in]]
) {
    metal::float4 v_1 = {};
    metal::float4 o = {};
    metal::float2 global_whole = {};
    const auto v = varyings.v;
    v_1 = v;
    main_1(v_1, o, global_whole);
    metal::float4 _e3 = o;
    const auto _tmp = FragmentOutput {_e3};
    return main_Output { _tmp.o };
}
