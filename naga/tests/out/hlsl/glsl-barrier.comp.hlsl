groupshared float values[64];
RWByteAddressBuffer global : register(u0);
static uint gl_LocalInvocationIndex_1 = (uint)0;
static uint3 gl_WorkGroupID_1 = (uint3)0;

void main_1()
{
    uint i = (uint)0;
    uint stride = 32u;

    uint _e4 = gl_LocalInvocationIndex_1;
    i = _e4;
    uint _e6 = i;
    uint _e8 = i;
    values[min(uint(_e6), 63u)] = float(_e8);
    GroupMemoryBarrierWithGroupSync();
    uint2 loop_bound = uint2(4294967295u, 4294967295u);
    bool loop_init = true;
    while(true) {
        if (all(loop_bound == uint2(0u, 0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            uint _e16 = stride;
            stride = (_e16 >> 1u);
        }
        loop_init = false;
        uint _e12 = stride;
        if (!((_e12 > 0u))) {
            break;
        }
        {
            uint _e19 = i;
            uint _e20 = stride;
            if ((_e19 < _e20)) {
                {
                    uint _e22 = i;
                    uint _e24 = i;
                    float _e26 = values[min(uint(_e24), 63u)];
                    uint _e27 = i;
                    uint _e28 = stride;
                    float _e31 = values[min(uint((_e27 + _e28)), 63u)];
                    values[min(uint(_e22), 63u)] = (_e26 + _e31);
                }
            }
            GroupMemoryBarrierWithGroupSync();
        }
    }
    uint _e33 = i;
    if ((_e33 == 0u)) {
        {
            uint3 _e37 = gl_WorkGroupID_1;
            float _e41 = values[0];
            global.Store(_e37.x*4+0, asuint(_e41));
            return;
        }
    } else {
        return;
    }
}

[numthreads(64, 1, 1)]
void main(uint gl_LocalInvocationIndex : SV_GroupIndex, uint3 gl_WorkGroupID : SV_GroupID)
{
    if (gl_LocalInvocationIndex == 0) {
        values = (float[64])0;
    }
    GroupMemoryBarrierWithGroupSync();
    gl_LocalInvocationIndex_1 = gl_LocalInvocationIndex;
    gl_WorkGroupID_1 = gl_WorkGroupID;
    main_1();
    return;
}
