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
var<private> offset_1: vec2<i32>;
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
    var j: vec4<f32>;
    var k: vec4<f32>;
    var l: vec4<u32>;
    var m: vec4<f32>;
    var n: vec4<f32>;

    let _e11 = uv_1;
    let _e12 = textureGather(0, tex2d, samp, _e11);
    a = _e12;
    let _e14 = uv_1;
    let _e15 = textureGather(3, tex2d, samp, _e14);
    b = _e15;
    let _e17 = uv_1;
    let _e18 = textureGather(2, tex2d, samp, _e17);
    c = _e18;
    let _e20 = uv_1;
    let _e24 = textureGather(0, tex2d, samp, _e20, vec2<i32>(1i, -1i));
    d = _e24;
    let _e26 = uv_1;
    let _e30 = vec3<f32>(_e26.x, _e26.y, 1f);
    let _e40 = textureGather(1, tex2dArray, samp, _e30.xy, i32(floor((_e30.z + 0.5f))), vec2<i32>(1i, 0i));
    e = _e40;
    let _e42 = uv_1;
    let _e47 = textureGather(0, texCube, samp, vec3<f32>(_e42.x, _e42.y, 1f));
    f = _e47;
    let _e49 = uv_1;
    let _e50 = textureGather(1, utex2d, samp, _e49);
    g = _e50;
    let _e52 = uv_1;
    let _e54 = textureGatherCompare(depth2d, sampShadow, _e52, 0.5f);
    h = _e54;
    let _e56 = uv_1;
    let _e60 = vec3<f32>(_e56.x, _e56.y, 2f);
    let _e71 = textureGatherCompare(depth2dArray, sampShadow, _e60.xy, i32(floor((_e60.z + 0.5f))), 0.5f, vec2<i32>(-1i, 1i));
    i = _e71;
    let _e73 = uv_1;
    let _e74 = offset_1;
    let _e76 = textureDimensions(tex2d, 0i);
    let _e81 = textureGather(2, tex2d, samp, (_e73 + (vec2<f32>(_e74) / vec2<f32>(_e76))));
    j = _e81;
    let _e83 = uv_1;
    let _e87 = vec3<f32>(_e83.x, _e83.y, 1.75f);
    let _e88 = offset_1;
    let _e96 = textureDimensions(tex2dArray, 0i);
    let _e101 = textureGather(0, tex2dArray, samp, (_e87.xy + (vec2<f32>(_e88) / vec2<f32>(_e96))), i32(floor((_e87.z + 0.5f))));
    k = _e101;
    let _e103 = uv_1;
    let _e104 = offset_1;
    let _e106 = textureDimensions(utex2d, 0i);
    let _e111 = textureGather(0, utex2d, samp, (_e103 + (vec2<f32>(_e104) / vec2<f32>(_e106))));
    l = _e111;
    let _e113 = uv_1;
    let _e115 = offset_1;
    let _e117 = textureDimensions(depth2d, 0i);
    let _e122 = textureGatherCompare(depth2d, sampShadow, (_e113 + (vec2<f32>(_e115) / vec2<f32>(_e117))), 0.5f);
    m = _e122;
    let _e124 = uv_1;
    let _e128 = vec3<f32>(_e124.x, _e124.y, 2.5f);
    let _e130 = offset_1;
    let _e138 = textureDimensions(depth2dArray, 0i);
    let _e143 = textureGatherCompare(depth2dArray, sampShadow, (_e128.xy + (vec2<f32>(_e130) / vec2<f32>(_e138))), i32(floor((_e128.z + 0.5f))), 0.5f);
    n = _e143;
    let _e145 = a;
    let _e146 = b;
    let _e148 = c;
    let _e150 = d;
    let _e152 = e;
    let _e154 = f;
    let _e156 = g;
    let _e159 = h;
    let _e161 = i;
    let _e163 = j;
    let _e165 = k;
    let _e167 = l;
    let _e170 = m;
    let _e172 = n;
    o = (((((((((((((_e145 + _e146) + _e148) + _e150) + _e152) + _e154) + vec4<f32>(_e156)) + _e159) + _e161) + _e163) + _e165) + vec4<f32>(_e167)) + _e170) + _e172);
    return;
}

@fragment 
fn main(@location(0) uv: vec2<f32>, @location(1) @interpolate(flat) offset: vec2<i32>) -> FragmentOutput {
    uv_1 = uv;
    offset_1 = offset;
    main_1();
    let _e5 = o;
    return FragmentOutput(_e5);
}
