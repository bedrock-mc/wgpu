#version 450
// `modf(x, out i)` and `frexp(x, out e)` lower to `Modf`/`Frexp` returning the
// predeclared result structs, with the second member stored to the `out`
// argument (directly, through a swizzle or through a global).

layout(location = 0) in vec4 v;
layout(location = 0) out vec4 o;

vec2 global_whole;

void main() {
    float whole;
    float fract_part = modf(v.x, whole);

    vec3 whole3;
    vec3 fract3 = modf(v.xyz, whole3);

    int e;
    float mantissa = frexp(v.w, e);

    ivec2 e2;
    vec2 mantissa2 = frexp(v.xy, e2);

    vec4 parts;
    parts.x = modf(v.y, parts.y);
    parts.zw = modf(v.zw, global_whole);

    o = vec4(fract_part + whole, fract3 + whole3)
        + vec4(mantissa * float(e), mantissa2 * vec2(e2), 0.0)
        + parts + global_whole.xyxy;
}
