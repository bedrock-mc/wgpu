struct _modf_result_f32_ {
    float fract;
    float whole;
};

struct _modf_result_vec3_f32_ {
    float3 fract;
    float3 whole;
};

struct _frexp_result_f32_ {
    float fract;
    int exp_;
};

struct _frexp_result_vec2_f32_ {
    float2 fract;
    int2 exp_;
};

struct _modf_result_vec2_f32_ {
    float2 fract;
    float2 whole;
};

struct FragmentOutput {
    float4 o : SV_Target0;
};

_modf_result_f32_ naga_modf(float arg) {
    float other;
    _modf_result_f32_ result;
    result.fract = modf(arg, other);
    result.whole = other;
    return result;
}

_modf_result_vec3_f32_ naga_modf(float3 arg) {
    float3 other;
    _modf_result_vec3_f32_ result;
    result.fract = modf(arg, other);
    result.whole = other;
    return result;
}

_frexp_result_f32_ naga_frexp(float arg) {
    float other;
    _frexp_result_f32_ result;
    result.fract = sign(arg) * frexp(arg, other);
    result.exp_ = other;
    return result;
}

_frexp_result_vec2_f32_ naga_frexp(float2 arg) {
    float2 other;
    _frexp_result_vec2_f32_ result;
    result.fract = sign(arg) * frexp(arg, other);
    result.exp_ = other;
    return result;
}

_modf_result_vec2_f32_ naga_modf(float2 arg) {
    float2 other;
    _modf_result_vec2_f32_ result;
    result.fract = modf(arg, other);
    result.whole = other;
    return result;
}

static float4 v_1 = (float4)0;
static float4 o = (float4)0;
static float2 global_whole = (float2)0;

struct FragmentInput_main {
    float4 v_2 : LOC0;
};

void main_1()
{
    float whole = (float)0;
    float fract_part = (float)0;
    float3 whole3_ = (float3)0;
    float3 fract3_ = (float3)0;
    int e = (int)0;
    float mantissa = (float)0;
    int2 e2_ = (int2)0;
    float2 mantissa2_ = (float2)0;
    float4 parts = (float4)0;
    float2 local = (float2)0;

    float4 _e4 = v_1;
    _modf_result_f32_ _e6 = naga_modf(_e4.x);
    whole = _e6.whole;
    fract_part = _e6.fract;
    float4 _e11 = v_1;
    _modf_result_vec3_f32_ _e13 = naga_modf(_e11.xyz);
    whole3_ = _e13.whole;
    fract3_ = _e13.fract;
    float4 _e18 = v_1;
    _frexp_result_f32_ _e20 = naga_frexp(_e18.w);
    e = _e20.exp_;
    mantissa = _e20.fract;
    float4 _e25 = v_1;
    _frexp_result_vec2_f32_ _e27 = naga_frexp(_e25.xy);
    e2_ = _e27.exp_;
    mantissa2_ = _e27.fract;
    float4 _e33 = v_1;
    _modf_result_f32_ _e36 = naga_modf(_e33.y);
    parts.y = _e36.whole;
    parts.x = _e36.fract;
    float4 _e39 = v_1;
    _modf_result_vec2_f32_ _e42 = naga_modf(_e39.zw);
    local = _e42.whole;
    float2 _e45 = local;
    global_whole = _e45;
    parts.z = _e42.fract.x;
    parts.w = _e42.fract.y;
    float _e50 = fract_part;
    float _e51 = whole;
    float3 _e53 = fract3_;
    float3 _e54 = whole3_;
    float3 _e55 = (_e53 + _e54);
    float _e60 = mantissa;
    int _e61 = e;
    float2 _e64 = mantissa2_;
    int2 _e65 = e2_;
    float2 _e67 = (_e64 * float2(_e65));
    float4 _e73 = parts;
    float2 _e75 = global_whole;
    o = (((float4((_e50 + _e51), _e55.x, _e55.y, _e55.z) + float4((_e60 * float(_e61)), _e67.x, _e67.y, 0.0)) + _e73) + _e75.xyxy);
    return;
}

FragmentOutput ConstructFragmentOutput(float4 arg0) {
    FragmentOutput ret = (FragmentOutput)0;
    ret.o = arg0;
    return ret;
}

FragmentOutput main(FragmentInput_main fragmentinput_main)
{
    float4 v = fragmentinput_main.v_2;
    v_1 = v;
    main_1();
    float4 _e3 = o;
    const FragmentOutput fragmentoutput = ConstructFragmentOutput(_e3);
    return fragmentoutput;
}
