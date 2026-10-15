#version 450
// Struct members are laid out with std140 strides while array constructors
// use the natural stride, so array arguments of struct constructors must be
// converted to the member's array type.

struct Params {
    float a;
    float lo[6];
    vec2 b[2];
};

layout(location = 0) in float x;
layout(location = 0) out vec4 o;

void main() {
    const Params c = Params(1.0, float[6](1.0, 2.0, 3.0, 4.0, 5.0, 6.0), vec2[2](vec2(1.0), vec2(2.0)));
    float lo[6] = float[6](x, 2.0, 3.0, 4.0, 5.0, 6.0);
    Params p = Params(x, lo, vec2[2](vec2(x), vec2(2.0)));
    o = vec4(c.lo[2] + p.lo[3], p.b[1], c.a);
}
