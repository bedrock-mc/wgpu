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
    metal::float2 local = {};
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
    _modf_result_f32_ _e36 = naga_modf(_e33.y);
    parts.y = _e36.whole;
    parts.x = _e36.fract;
    metal::float4 _e39 = v_1;
    _modf_result_vec2_f32_ _e42 = naga_modf(_e39.zw);
    local = _e42.whole;
    metal::float2 _e45 = local;
    global_whole = _e45;
    parts.z = _e42.fract.x;
    parts.w = _e42.fract.y;
    float _e50 = fract_part;
    float _e51 = whole;
    metal::float3 _e53 = fract3_;
    metal::float3 _e54 = whole3_;
    metal::float3 _e55 = _e53 + _e54;
    float _e60 = mantissa;
    int _e61 = e;
    metal::float2 _e64 = mantissa2_;
    metal::int2 _e65 = e2_;
    metal::float2 _e67 = _e64 * static_cast<metal::float2>(_e65);
    metal::float4 _e73 = parts;
    metal::float2 _e75 = global_whole;
    o = ((metal::float4(_e50 + _e51, _e55.x, _e55.y, _e55.z) + metal::float4(_e60 * static_cast<float>(_e61), _e67.x, _e67.y, 0.0)) + _e73) + _e75.xyxy;
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
