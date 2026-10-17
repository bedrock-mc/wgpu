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
static int2 offset_1 = (int2)0;
static float4 o = (float4)0;

struct FragmentInput_main {
    float2 uv_2 : LOC0;
    nointerpolation int2 offset_2 : LOC1;
};

int naga_f2i32(float value) {
    return int(clamp(value, -2147483600.0, 2147483500.0));
}

uint2 NagaMipDimensions2D(Texture2D<float4> tex, uint mip_level)
{
    uint4 ret;
    tex.GetDimensions(mip_level, ret.x, ret.y, ret.z);
    return ret.xy;
}

uint2 NagaMipDimensions2DArray(Texture2DArray<float4> tex, uint mip_level)
{
    uint4 ret;
    tex.GetDimensions(mip_level, ret.x, ret.y, ret.z, ret.w);
    return ret.xy;
}

uint2 NagaMipDimensions2D(Texture2D<uint4> tex, uint mip_level)
{
    uint4 ret;
    tex.GetDimensions(mip_level, ret.x, ret.y, ret.z);
    return ret.xy;
}

uint2 NagaDepthMipDimensions2D(Texture2D<float> tex, uint mip_level)
{
    uint4 ret;
    tex.GetDimensions(mip_level, ret.x, ret.y, ret.z);
    return ret.xy;
}

uint2 NagaDepthMipDimensions2DArray(Texture2DArray<float> tex, uint mip_level)
{
    uint4 ret;
    tex.GetDimensions(mip_level, ret.x, ret.y, ret.z, ret.w);
    return ret.xy;
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
    float4 j = (float4)0;
    float4 k = (float4)0;
    uint4 l = (uint4)0;
    float4 m = (float4)0;
    float4 n = (float4)0;

    float2 _e11 = uv_1;
    float4 _e12 = tex2d.Gather(samp, _e11);
    a = _e12;
    float2 _e14 = uv_1;
    float4 _e15 = tex2d.GatherAlpha(samp, _e14);
    b = _e15;
    float2 _e17 = uv_1;
    float4 _e18 = tex2d.GatherBlue(samp, _e17);
    c = _e18;
    float2 _e20 = uv_1;
    float4 _e24 = tex2d.Gather(samp, _e20, int2(int2(int(1), int(-1))));
    d = _e24;
    float2 _e26 = uv_1;
    float3 _e30 = float3(_e26.x, _e26.y, 1.0);
    float4 _e40 = tex2dArray.GatherGreen(samp, float3(_e30.xy, naga_f2i32(floor((_e30.z + 0.5)))), int2(int2(int(1), int(0))));
    e = _e40;
    float2 _e42 = uv_1;
    float4 _e47 = texCube.Gather(samp, float3(_e42.x, _e42.y, 1.0));
    f = _e47;
    float2 _e49 = uv_1;
    uint4 _e50 = utex2d.GatherGreen(samp, _e49);
    g = _e50;
    float2 _e52 = uv_1;
    float4 _e54 = depth2d.GatherCmp(sampShadow, _e52, 0.5);
    h = _e54;
    float2 _e56 = uv_1;
    float3 _e60 = float3(_e56.x, _e56.y, 2.0);
    float4 _e71 = depth2dArray.GatherCmp(sampShadow, float3(_e60.xy, naga_f2i32(floor((_e60.z + 0.5)))), 0.5, int2(int2(int(-1), int(1))));
    i = _e71;
    float2 _e73 = uv_1;
    int2 _e74 = offset_1;
    float4 _e81 = tex2d.GatherBlue(samp, (_e73 + (float2(_e74) / float2(NagaMipDimensions2D(tex2d, int(0))))));
    j = _e81;
    float2 _e83 = uv_1;
    float3 _e87 = float3(_e83.x, _e83.y, 1.75);
    int2 _e88 = offset_1;
    float4 _e101 = tex2dArray.Gather(samp, float3((_e87.xy + (float2(_e88) / float2(NagaMipDimensions2DArray(tex2dArray, int(0))))), naga_f2i32(floor((_e87.z + 0.5)))));
    k = _e101;
    float2 _e103 = uv_1;
    int2 _e104 = offset_1;
    uint4 _e111 = utex2d.Gather(samp, (_e103 + (float2(_e104) / float2(NagaMipDimensions2D(utex2d, int(0))))));
    l = _e111;
    float2 _e113 = uv_1;
    int2 _e115 = offset_1;
    float4 _e122 = depth2d.GatherCmp(sampShadow, (_e113 + (float2(_e115) / float2(NagaDepthMipDimensions2D(depth2d, int(0))))), 0.5);
    m = _e122;
    float2 _e124 = uv_1;
    float3 _e128 = float3(_e124.x, _e124.y, 2.5);
    int2 _e130 = offset_1;
    float4 _e143 = depth2dArray.GatherCmp(sampShadow, float3((_e128.xy + (float2(_e130) / float2(NagaDepthMipDimensions2DArray(depth2dArray, int(0))))), naga_f2i32(floor((_e128.z + 0.5)))), 0.5);
    n = _e143;
    float4 _e145 = a;
    float4 _e146 = b;
    float4 _e148 = c;
    float4 _e150 = d;
    float4 _e152 = e;
    float4 _e154 = f;
    uint4 _e156 = g;
    float4 _e159 = h;
    float4 _e161 = i;
    float4 _e163 = j;
    float4 _e165 = k;
    uint4 _e167 = l;
    float4 _e170 = m;
    float4 _e172 = n;
    o = (((((((((((((_e145 + _e146) + _e148) + _e150) + _e152) + _e154) + float4(_e156)) + _e159) + _e161) + _e163) + _e165) + float4(_e167)) + _e170) + _e172);
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
    int2 offset = fragmentinput_main.offset_2;
    uv_1 = uv;
    offset_1 = offset;
    main_1();
    float4 _e5 = o;
    const FragmentOutput fragmentoutput = ConstructFragmentOutput(_e5);
    return fragmentoutput;
}
