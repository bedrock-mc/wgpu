#version 450
// `%` between an integer vector and a scalar splats the scalar, like the other
// arithmetic operators.

layout(location = 0) flat in ivec2 v;
layout(location = 1) flat in uint u;
layout(location = 0) out vec4 o;

void main() {
    ivec2 a = v % 4;
    ivec2 b = 7 % v;
    uvec3 c = uvec3(u) % 3u;
    uvec3 d = 9u % uvec3(u);
    o = vec4(a, b) + vec4(c, 0) + vec4(d, 0);
}
