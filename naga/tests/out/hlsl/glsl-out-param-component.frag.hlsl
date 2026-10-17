struct FragmentOutput {
    float4 o : SV_Target0;
};

static float4 v_1 = (float4)0;
static float4 o = (float4)0;

struct FragmentInput_main {
    float4 v_2 : LOC0;
};

void split(float x, inout float whole, inout float acc)
{
    float x_1 = (float)0;

    x_1 = x;
    float _e4 = x_1;
    whole = floor(_e4);
    float _e6 = acc;
    float _e7 = x_1;
    float _e8 = whole;
    acc = (_e6 + (_e7 - _e8));
    return;
}

void main_1()
{
    float4 parts = (0.0).xxxx;
    float2x2 m = float2x2(float2(1.0, 0.0), float2(0.0, 1.0));
    float local = (float)0;
    float local_1 = (float)0;
    float local_2 = (float)0;
    float local_3 = (float)0;
    float local_4 = (float)0;
    float local_5 = (float)0;

    float4 _e11 = v_1;
    float _e16 = parts.w;
    local_1 = _e16;
    split(_e11.x, local, local_1);
    float _e18 = local;
    parts.y = _e18;
    float _e19 = local_1;
    parts.w = _e19;
    float4 _e20 = v_1;
    float _e31 = m[int(0)][int(1)];
    local_3 = _e31;
    split(_e20.y, local_2, local_3);
    float _e33 = local_2;
    m[int(1)][int(0)] = _e33;
    float _e34 = local_3;
    m[int(0)][int(1)] = _e34;
    float4 _e35 = v_1;
    float _e44 = m[int(1)][int(1)];
    local_5 = _e44;
    split(_e35.z, local_4, local_5);
    float _e46 = local_4;
    parts[int(2)] = _e46;
    float _e47 = local_5;
    m[int(1)][int(1)] = _e47;
    float4 _e48 = parts;
    float2 _e50 = m[0];
    float2 _e52 = m[1];
    o = (_e48 + float4(_e50.x, _e50.y, _e52.x, _e52.y));
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
