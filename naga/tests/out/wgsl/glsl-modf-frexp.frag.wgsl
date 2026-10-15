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
    var local: vec2<f32>;

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
    let _e36 = modf(_e33.y);
    parts.y = _e36.whole;
    parts.x = _e36.fract;
    let _e39 = v_1;
    let _e42 = modf(_e39.zw);
    local = _e42.whole;
    let _e45 = local;
    global_whole = _e45;
    parts.z = _e42.fract.x;
    parts.w = _e42.fract.y;
    let _e50 = fract_part;
    let _e51 = whole;
    let _e53 = fract3_;
    let _e54 = whole3_;
    let _e55 = (_e53 + _e54);
    let _e60 = mantissa;
    let _e61 = e;
    let _e64 = mantissa2_;
    let _e65 = e2_;
    let _e67 = (_e64 * vec2<f32>(_e65));
    let _e73 = parts;
    let _e75 = global_whole;
    o = (((vec4<f32>((_e50 + _e51), _e55.x, _e55.y, _e55.z) + vec4<f32>((_e60 * f32(_e61)), _e67.x, _e67.y, 0f)) + _e73) + _e75.xyxy);
    return;
}

@fragment 
fn main(@location(0) v: vec4<f32>) -> FragmentOutput {
    v_1 = v;
    main_1();
    let _e3 = o;
    return FragmentOutput(_e3);
}
