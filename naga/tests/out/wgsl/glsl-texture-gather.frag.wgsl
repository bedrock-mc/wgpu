struct FragmentOutput {
    @location(0) o: vec4<f32>,
}

const COMPONENT: i32 = 2i;

@group(0) @binding(0) 
var tex2d: texture_2d<f32>;
@group(0) @binding(1) 
var tex2dArray: texture_2d_array<f32>;
@group(0) @binding(2) 
var texCube: texture_cube<f32>;
@group(0) @binding(3) 
var utex2d: texture_2d<u32>;
@group(0) @binding(4) 
var depth2d: texture_depth_2d;
@group(0) @binding(5) 
var depth2dArray: texture_depth_2d_array;
@group(0) @binding(6) 
var samp: sampler;
@group(0) @binding(7) 
var sampShadow: sampler_comparison;
var<private> uv_1: vec2<f32>;
var<private> o: vec4<f32>;

fn main_1() {
    var a: vec4<f32>;
    var b: vec4<f32>;
    var c: vec4<f32>;
    var d: vec4<f32>;
    var e: vec4<f32>;
    var f: vec4<f32>;
    var g: vec4<u32>;
    var h: vec4<f32>;
    var i: vec4<f32>;

    let _e10 = uv_1;
    let _e11 = textureGather(0, tex2d, samp, _e10);
    a = _e11;
    let _e13 = uv_1;
    let _e14 = textureGather(3, tex2d, samp, _e13);
    b = _e14;
    let _e16 = uv_1;
    let _e17 = textureGather(2, tex2d, samp, _e16);
    c = _e17;
    let _e19 = uv_1;
    let _e23 = textureGather(0, tex2d, samp, _e19, vec2<i32>(1i, -1i));
    d = _e23;
    let _e25 = uv_1;
    let _e29 = vec3<f32>(_e25.x, _e25.y, 1f);
    let _e36 = textureGather(1, tex2dArray, samp, _e29.xy, i32(_e29.z), vec2<i32>(1i, 0i));
    e = _e36;
    let _e38 = uv_1;
    let _e43 = textureGather(0, texCube, samp, vec3<f32>(_e38.x, _e38.y, 1f));
    f = _e43;
    let _e45 = uv_1;
    let _e46 = textureGather(1, utex2d, samp, _e45);
    g = _e46;
    let _e48 = uv_1;
    let _e50 = textureGatherCompare(depth2d, sampShadow, _e48, 0.5f);
    h = _e50;
    let _e52 = uv_1;
    let _e56 = vec3<f32>(_e52.x, _e52.y, 2f);
    let _e64 = textureGatherCompare(depth2dArray, sampShadow, _e56.xy, i32(_e56.z), 0.5f, vec2<i32>(-1i, 1i));
    i = _e64;
    let _e66 = a;
    let _e67 = b;
    let _e69 = c;
    let _e71 = d;
    let _e73 = e;
    let _e75 = f;
    let _e77 = g;
    let _e80 = h;
    let _e82 = i;
    o = ((((((((_e66 + _e67) + _e69) + _e71) + _e73) + _e75) + vec4<f32>(_e77)) + _e80) + _e82);
    return;
}

@fragment 
fn main(@location(0) uv: vec2<f32>) -> FragmentOutput {
    uv_1 = uv;
    main_1();
    let _e3 = o;
    return FragmentOutput(_e3);
}
