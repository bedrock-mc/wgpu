// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct _mslBufferSizes {
    uint size1;
};

struct type_1 {
    float inner[64];
};
typedef float type_2[1];
struct Output {
    type_2 result;
};

void main_1(
    threadgroup type_1& values,
    device Output& global,
    thread uint& gl_LocalInvocationIndex_1,
    thread metal::uint3& gl_WorkGroupID_1,
    constant _mslBufferSizes& _buffer_sizes
) {
    uint i = {};
    uint stride = 32u;
    uint _e4 = gl_LocalInvocationIndex_1;
    i = _e4;
    uint _e6 = i;
    uint _e8 = i;
    values.inner[_e6] = static_cast<float>(_e8);
    metal::threadgroup_barrier(metal::mem_flags::mem_threadgroup);
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            uint _e16 = stride;
            stride = _e16 >> 1u;
        }
        loop_init = false;
        uint _e12 = stride;
        if (!((_e12 > 0u))) {
            break;
        }
        {
            uint _e19 = i;
            uint _e20 = stride;
            if (_e19 < _e20) {
                {
                    uint _e22 = i;
                    uint _e24 = i;
                    float _e26 = values.inner[_e24];
                    uint _e27 = i;
                    uint _e28 = stride;
                    float _e31 = values.inner[_e27 + _e28];
                    values.inner[_e22] = _e26 + _e31;
                }
            }
            metal::threadgroup_barrier(metal::mem_flags::mem_threadgroup);
        }
    }
    uint _e33 = i;
    if (_e33 == 0u) {
        {
            metal::uint3 _e37 = gl_WorkGroupID_1;
            float _e41 = values.inner[0];
            global.result[_e37.x] = _e41;
            return;
        }
    } else {
        return;
    }
}

struct main_Input {
};
kernel void main_(
  uint gl_LocalInvocationIndex [[thread_index_in_threadgroup]]
, metal::uint3 gl_WorkGroupID [[threadgroup_position_in_grid]]
, threadgroup type_1& values
, device Output& global [[user(fake0)]]
, constant _mslBufferSizes& _buffer_sizes [[user(fake0)]]
) {
    uint gl_LocalInvocationIndex_1 = {};
    metal::uint3 gl_WorkGroupID_1 = {};
    if (gl_LocalInvocationIndex == 0u) {
        values = {};
    }
    metal::threadgroup_barrier(metal::mem_flags::mem_threadgroup);
    gl_LocalInvocationIndex_1 = gl_LocalInvocationIndex;
    gl_WorkGroupID_1 = gl_WorkGroupID;
    main_1(values, global, gl_LocalInvocationIndex_1, gl_WorkGroupID_1, _buffer_sizes);
    return;
}
