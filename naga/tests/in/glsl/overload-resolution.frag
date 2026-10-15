#version 450
// Overload resolution with implicit conversions (GLSL 4.60 § 6.1): an overload
// is selected when it is better than every other viable one, counting exact
// argument matches as better than any conversion.

uint pick(uint a, uint b) { return a + b; }
float pick(float a, float b) { return a * b; }

layout(location = 0) flat in int i;
layout(location = 0) out vec4 o;

void main() {
    // `clamp(uint, uint, uint)` needs one int -> uint conversion and is exact
    // for the other two arguments, so it beats `clamp(float, float, float)`.
    uint c = clamp(i, 0u, 31u);
    // `max(uint, uint)` against `max(float, float)`.
    uint m = max(i, 3u);
    // User-defined overloads follow the same rules.
    uint p = pick(i, 1u);
    float q = pick(i, 1.0);
    o = vec4(float(c), float(m), float(p), q);
}
