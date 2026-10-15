#version 450
// Vector and matrix components passed to `out`/`inout` parameters are spilled
// to a local: a pointer to a component can't be a function argument (WGSL
// can't take its address, SPIR-V requires memory object declarations).

layout(location = 0) in vec4 v;
layout(location = 0) out vec4 o;

void split(float x, out float whole, inout float acc) {
    whole = floor(x);
    acc += x - whole;
}

void main() {
    vec4 parts = vec4(0.0);
    mat2 m = mat2(1.0);
    split(v.x, parts.y, parts.w);
    split(v.y, m[1][0], m[0][1]);
    split(v.z, parts[2], m[1][1]);
    o = parts + vec4(m[0], m[1]);
}
