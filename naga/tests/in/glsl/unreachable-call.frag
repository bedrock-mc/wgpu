#version 450
// Statements after `return`/`discard`/`break`/`continue` are dropped. Calls
// among them must not leave behind results that no statement visits.

layout(location = 0) in vec3 v;
layout(location = 0) out vec4 o;

vec2 scale(vec2 c, float w) {
    return c * w;
}

float early() {
    return 1.0;
    float unused = scale(v.xy, 2.0).x;
}

void main() {
    for (int i = 0; i < 2; i++) {
        if (v.x > 0.0) {
            break;
            o = vec4(scale(v.xy, 3.0), 0.0, 0.0);
        }
    }
    o = vec4(early());
    if (v.z < 0.0) {
        discard;
        vec3 a = vec3(scale(v.xy, -0.5), v.z);
        o = vec4(a, 1.0);
    }
}
