#version 460
layout(local_size_x = 64, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer _8_12
{
    float _m0[];
} _12;

shared float _10[64];
uint _14 = 0u;
uvec3 _17 = uvec3(0u);

void _21()
{
    uint _26 = 0u;
    uint _29 = 32u;
    uvec2 _51 = uvec2(4294967295u);
    _26 = _14;
    _10[_26] = float(_26);
    barrier();
    for (;;)
    {
        if (all(equal(uvec2(0u), _51)))
        {
            break;
        }
        _51 -= uvec2(uint(_51.y == 0u), 1u);
        if (!(_29 > 0u))
        {
            break;
        }
        if (_26 < _29)
        {
            _10[_26] += _10[_26 + _29];
        }
        barrier();
        _29 = _29 >> 1u;
        continue;
    }
    if (_26 == 0u)
    {
        _12._m0[_17.x] = _10[0u];
        return;
    }
    else
    {
        return;
    }
}

void main()
{
    if (gl_LocalInvocationIndex == 0u)
    {
        _10 = float[](0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    }
    barrier();
    _14 = gl_LocalInvocationIndex;
    _17 = gl_WorkGroupID;
    _21();
}

