struct FragmentOutput {
    @location(0) o: vec4<f32>,
}

var<private> v_1: vec4<f32>;
var<private> o: vec4<f32>;
var<private> global_whole: vec2<f32>;

fn main_1() {
    var whole: f32;
    var fract_part: f32;
    var whole3_: vec3<f32>;
    var fract3_: vec3<f32>;
    var e: i32;
    var mantissa: f32;
    var e2_: vec2<i32>;
    var mantissa2_: vec2<f32>;
    var parts: vec4<f32>;
    var local: f32;
    var local_1: vec2<f32>;

    let _e4 = v_1;
    let _e6 = modf(_e4.x);
    whole = _e6.whole;
    fract_part = _e6.fract;
    let _e11 = v_1;
    let _e13 = modf(_e11.xyz);
    whole3_ = _e13.whole;
    fract3_ = _e13.fract;
    let _e18 = v_1;
    let _e20 = frexp(_e18.w);
    e = _e20.exp;
    mantissa = _e20.fract;
    let _e25 = v_1;
    let _e27 = frexp(_e25.xy);
    e2_ = _e27.exp;
    mantissa2_ = _e27.fract;
    let _e33 = v_1;
    let _e37 = modf(_e33.y);
    local = _e37.whole;
    let _e40 = local;
    parts.y = _e40;
    parts.x = _e37.fract;
    let _e41 = v_1;
    let _e44 = modf(_e41.zw);
    local_1 = _e44.whole;
    let _e47 = local_1;
    global_whole = _e47;
    parts.z = _e44.fract.x;
    parts.w = _e44.fract.y;
    let _e52 = fract_part;
    let _e53 = whole;
    let _e55 = fract3_;
    let _e56 = whole3_;
    let _e57 = (_e55 + _e56);
    let _e62 = mantissa;
    let _e63 = e;
    let _e66 = mantissa2_;
    let _e67 = e2_;
    let _e69 = (_e66 * vec2<f32>(_e67));
    let _e75 = parts;
    let _e77 = global_whole;
    o = (((vec4<f32>((_e52 + _e53), _e57.x, _e57.y, _e57.z) + vec4<f32>((_e62 * f32(_e63)), _e69.x, _e69.y, 0f)) + _e75) + _e77.xyxy);
    return;
}

@fragment 
fn main(@location(0) v: vec4<f32>) -> FragmentOutput {
    v_1 = v;
    main_1();
    let _e3 = o;
    return FragmentOutput(_e3);
}
