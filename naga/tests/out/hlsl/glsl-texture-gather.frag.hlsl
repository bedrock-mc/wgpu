struct FragmentOutput {
    float4 o : SV_Target0;
};

static const int COMPONENT = int(2);

Texture2D<float4> tex2d : register(t0);
Texture2DArray<float4> tex2dArray : register(t1);
TextureCube<float4> texCube : register(t2);
Texture2D<uint4> utex2d : register(t3);
Texture2D<float> depth2d : register(t4);
Texture2DArray<float> depth2dArray : register(t5);
SamplerState nagaSamplerHeap[2048]: register(s0, space0);
SamplerComparisonState nagaComparisonSamplerHeap[2048]: register(s0, space1);
StructuredBuffer<uint> nagaGroup0SamplerIndexArray : register(t0, space255);
static const SamplerState samp = nagaSamplerHeap[nagaGroup0SamplerIndexArray[6]];
static const SamplerComparisonState sampShadow = nagaComparisonSamplerHeap[nagaGroup0SamplerIndexArray[7]];
static float2 uv_1 = (float2)0;
static float4 o = (float4)0;

struct FragmentInput_main {
    float2 uv_2 : LOC0;
};

int naga_f2i32(float value) {
    return int(clamp(value, -2147483600.0, 2147483500.0));
}

void main_1()
{
    float4 a = (float4)0;
    float4 b = (float4)0;
    float4 c = (float4)0;
    float4 d = (float4)0;
    float4 e = (float4)0;
    float4 f = (float4)0;
    uint4 g = (uint4)0;
    float4 h = (float4)0;
    float4 i = (float4)0;

    float2 _e10 = uv_1;
    float4 _e11 = tex2d.Gather(samp, _e10);
    a = _e11;
    float2 _e13 = uv_1;
    float4 _e14 = tex2d.GatherAlpha(samp, _e13);
    b = _e14;
    float2 _e16 = uv_1;
    float4 _e17 = tex2d.GatherBlue(samp, _e16);
    c = _e17;
    float2 _e19 = uv_1;
    float4 _e23 = tex2d.Gather(samp, _e19, int2(int2(int(1), int(-1))));
    d = _e23;
    float2 _e25 = uv_1;
    float3 _e29 = float3(_e25.x, _e25.y, 1.0);
    float4 _e36 = tex2dArray.GatherGreen(samp, float3(_e29.xy, naga_f2i32(_e29.z)), int2(int2(int(1), int(0))));
    e = _e36;
    float2 _e38 = uv_1;
    float4 _e43 = texCube.Gather(samp, float3(_e38.x, _e38.y, 1.0));
    f = _e43;
    float2 _e45 = uv_1;
    uint4 _e46 = utex2d.GatherGreen(samp, _e45);
    g = _e46;
    float2 _e48 = uv_1;
    float4 _e50 = depth2d.GatherCmp(sampShadow, _e48, 0.5);
    h = _e50;
    float2 _e52 = uv_1;
    float3 _e56 = float3(_e52.x, _e52.y, 2.0);
    float4 _e64 = depth2dArray.GatherCmp(sampShadow, float3(_e56.xy, naga_f2i32(_e56.z)), 0.5, int2(int2(int(-1), int(1))));
    i = _e64;
    float4 _e66 = a;
    float4 _e67 = b;
    float4 _e69 = c;
    float4 _e71 = d;
    float4 _e73 = e;
    float4 _e75 = f;
    uint4 _e77 = g;
    float4 _e80 = h;
    float4 _e82 = i;
    o = ((((((((_e66 + _e67) + _e69) + _e71) + _e73) + _e75) + float4(_e77)) + _e80) + _e82);
    return;
}

FragmentOutput ConstructFragmentOutput(float4 arg0) {
    FragmentOutput ret = (FragmentOutput)0;
    ret.o = arg0;
    return ret;
}

FragmentOutput main(FragmentInput_main fragmentinput_main)
{
    float2 uv = fragmentinput_main.uv_2;
    uv_1 = uv;
    main_1();
    float4 _e3 = o;
    const FragmentOutput fragmentoutput = ConstructFragmentOutput(_e3);
    return fragmentoutput;
}
