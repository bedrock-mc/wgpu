#version 450
// Numeric constructors from booleans: a scalar bool splats to every
// component, a bool vector is resized to the result.

layout(location = 0) flat in int x;
layout(location = 0) out vec4 o;

vec3 tint(bool b) {
    return vec3(b);
}

void main() {
    bool b = x > 0;
    bvec3 bv = bvec3(b, !b, true);
    vec3 a = tint(b);
    ivec2 i = ivec2(bv);
    uvec4 u = uvec4(b);
    float f = float(bv);
    o = vec4(a, f) + vec4(i, 0, 0) + vec4(u);
}
