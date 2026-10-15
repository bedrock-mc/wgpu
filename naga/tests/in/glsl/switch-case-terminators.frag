#version 450
// Cases that end in `return`, `discard` or `continue` do not fall through to
// the next case, so they must not be lowered as fall-through blocks (which the
// WGSL backend cannot express).

layout(location = 0) flat in int sel;
layout(location = 0) out vec4 o;

vec4 pick(int s) {
    switch (s) {
        case 0:
        case 1:
            return vec4(1.0);
        case 2:
            return vec4(2.0);
        default:
            return vec4(0.0);
    }
}

void main() {
    o = pick(sel);
    for (int i = 0; i < 4; i++) {
        switch (i) {
            case 1:
                o.x += 1.0;
                continue;
            case 2:
                o.y += 1.0;
                break;
            default:
                o.z += 1.0;
                break;
        }
    }
    switch (sel) {
        case 3:
            o *= 2.0;
            discard;
        default:
            break;
    }
}
