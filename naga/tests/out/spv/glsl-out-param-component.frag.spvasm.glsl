#version 460

struct _8
{
    vec4 _m0;
};

layout(location = 0) in vec4 _104;
layout(location = 0) out vec4 _107;
vec4 _9 = vec4(0.0);
vec4 _12 = vec4(0.0);

void _17(float _14, inout float _15, inout float _16)
{
    float _19 = 0.0;
    _19 = _14;
    _15 = floor(_19);
    _16 += (_19 - _15);
}

void _30()
{
    float _54 = 0.0;
    float _48 = 0.0;
    vec4 _42 = vec4(0.0);
    float _56 = 0.0;
    float _50 = 0.0;
    mat2 _44 = mat2(vec2(1.0, 0.0), vec2(0.0, 1.0));
    float _52 = 0.0;
    float _46 = 0.0;
    _48 = _42.w;
    _17(_9.x, _46, _48);
    _42.y = _46;
    _42.w = _48;
    _52 = _44[0u].y;
    _17(_9.y, _50, _52);
    _44[1u].x = _50;
    _44[0u].y = _52;
    _56 = _44[1u].y;
    _17(_9.z, _54, _56);
    _42.z = _54;
    _44[1u].y = _56;
    _12 = _42 + vec4(_44[0u], _44[1u]);
}

void main()
{
    _9 = _104;
    _30();
    _107 = _8(_12)._m0;
}

