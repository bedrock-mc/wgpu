#version 460

struct _7
{
    float _m0;
    float _m1;
};

struct _8
{
    vec3 _m0;
    vec3 _m1;
};

struct _11
{
    float _m0;
    int _m1;
};

struct _12
{
    vec2 _m0;
    ivec2 _m1;
};

struct _13
{
    vec2 _m0;
    vec2 _m1;
};

struct _14
{
    vec4 _m0;
};

layout(location = 0) in vec4 _123;
layout(location = 0) out vec4 _126;
vec4 _15 = vec4(0.0);
vec4 _18 = vec4(0.0);
vec2 _19 = vec2(0.0);

void _23()
{
    vec2 _50 = vec2(0.0);
    ivec2 _41 = ivec2(0);
    vec3 _34 = vec3(0.0);
    float _26 = 0.0;
    vec2 _44 = vec2(0.0);
    int _36 = 0;
    float _29 = 0.0;
    vec4 _47 = vec4(0.0);
    float _39 = 0.0;
    vec3 _31 = vec3(0.0);
    _7 _55;
    _55._m0 = modf(_15.x, _55._m1);
    _26 = _55._m1;
    _29 = _55._m0;
    _8 _60;
    _60._m0 = modf(_15.xyz, _60._m1);
    _31 = _60._m1;
    _34 = _60._m0;
    _11 _65;
    _65._m0 = frexp(_15.w, _65._m1);
    _36 = _65._m1;
    _39 = _65._m0;
    _12 _70;
    _70._m0 = frexp(_15.xy, _70._m1);
    _41 = _70._m1;
    _44 = _70._m0;
    _7 _75;
    _75._m0 = modf(_15.y, _75._m1);
    _47.y = _75._m1;
    _47.x = _75._m0;
    _13 _85;
    _85._m0 = modf(_15.zw, _85._m1);
    _50 = _85._m1;
    _19 = _50;
    _47.z = _85._m0.x;
    _47.w = _85._m0.y;
    _18 = ((vec4(_29 + _26, _34 + _31) + vec4(_39 * float(_36), _44 * vec2(_41), 0.0)) + _47) + _19.xyxy;
}

void main()
{
    _15 = _123;
    _23();
    _126 = _14(_18)._m0;
}

