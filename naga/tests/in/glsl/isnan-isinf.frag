#version 450
// WGSL has no isNan/isInf; the WGSL backend tests the exponent and mantissa
// bits instead.

layout(location = 0) in vec4 v;
layout(location = 0) out vec4 o;

void main() {
    bool a = isnan(v.x);
    bool b = isinf(v.y);
    bvec3 c = isnan(v.xyz);
    bvec4 d = isinf(v);
    o = vec4(float(a), float(b), float(any(c)), float(all(d)));
}
