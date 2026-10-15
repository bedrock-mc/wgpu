// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct FragmentOutput {
    metal::float4 o;
};

void split(
    float x,
    thread float& whole,
    thread float& acc
) {
    float x_1 = {};
    x_1 = x;
    float _e4 = x_1;
    whole = metal::floor(_e4);
    float _e6 = acc;
    float _e7 = x_1;
    float _e8 = whole;
    acc = _e6 + (_e7 - _e8);
    return;
}

void main_1(
    thread metal::float4& v_1,
    thread metal::float4& o
) {
    metal::float4 parts = metal::float4(0.0);
    metal::float2x2 m = metal::float2x2(metal::float2(1.0, 0.0), metal::float2(0.0, 1.0));
    float local = {};
    float local_1 = {};
    float local_2 = {};
    float local_3 = {};
    float local_4 = {};
    float local_5 = {};
    metal::float4 _e11 = v_1;
    float _e16 = parts.w;
    local_1 = _e16;
    split(_e11.x, local, local_1);
    float _e18 = local;
    parts.y = _e18;
    float _e19 = local_1;
    parts.w = _e19;
    metal::float4 _e20 = v_1;
    float _e31 = m[0][1];
    local_3 = _e31;
    split(_e20.y, local_2, local_3);
    float _e33 = local_2;
    m[1][0] = _e33;
    float _e34 = local_3;
    m[0][1] = _e34;
    metal::float4 _e35 = v_1;
    float _e44 = m[1][1];
    local_5 = _e44;
    split(_e35.z, local_4, local_5);
    float _e46 = local_4;
    parts[2] = _e46;
    float _e47 = local_5;
    m[1][1] = _e47;
    metal::float4 _e48 = parts;
    metal::float2 _e50 = m[0];
    metal::float2 _e52 = m[1];
    o = _e48 + metal::float4(_e50.x, _e50.y, _e52.x, _e52.y);
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
    const auto v = varyings.v;
    v_1 = v;
    main_1(v_1, o);
    metal::float4 _e3 = o;
    const auto _tmp = FragmentOutput {_e3};
    return main_Output { _tmp.o };
}
