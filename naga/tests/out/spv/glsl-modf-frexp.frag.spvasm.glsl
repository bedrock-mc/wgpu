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

layout(location = 0) in vec4 _126;
layout(location = 0) out vec4 _129;
vec4 _15 = vec4(0.0);
vec4 _18 = vec4(0.0);
vec2 _19 = vec2(0.0);

void _23()
{
    float _50 = 0.0;
    ivec2 _41 = ivec2(0);
    vec3 _34 = vec3(0.0);
    float _26 = 0.0;
    vec2 _52 = vec2(0.0);
    vec2 _44 = vec2(0.0);
    int _36 = 0;
    float _29 = 0.0;
    vec4 _47 = vec4(0.0);
    float _39 = 0.0;
    vec3 _31 = vec3(0.0);
    _7 _57;
    _57._m0 = modf(_15.x, _57._m1);
    _26 = _57._m1;
    _29 = _57._m0;
    _8 _62;
    _62._m0 = modf(_15.xyz, _62._m1);
    _31 = _62._m1;
    _34 = _62._m0;
    _11 _67;
    _67._m0 = frexp(_15.w, _67._m1);
    _36 = _67._m1;
    _39 = _67._m0;
    _12 _72;
    _72._m0 = frexp(_15.xy, _72._m1);
    _41 = _72._m1;
    _44 = _72._m0;
    _7 _77;
    _77._m0 = modf(_15.y, _77._m1);
    _50 = _77._m1;
    _47.y = _50;
    _47.x = _77._m0;
    _13 _88;
    _88._m0 = modf(_15.zw, _88._m1);
    _52 = _88._m1;
    _19 = _52;
    _47.z = _88._m0.x;
    _47.w = _88._m0.y;
    _18 = ((vec4(_29 + _26, _34 + _31) + vec4(_39 * float(_36), _44 * vec2(_41), 0.0)) + _47) + _19.xyxy;
}

void main()
{
    _15 = _126;
    _23();
    _129 = _14(_18)._m0;
}

