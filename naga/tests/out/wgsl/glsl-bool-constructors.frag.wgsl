struct FragmentOutput {
    @location(0) o: vec4<f32>,
}

var<private> x_1: i32;
var<private> o: vec4<f32>;

fn tint(b: bool) -> vec3<f32> {
    var b_1: bool;

    b_1 = b;
    let _e2 = b_1;
    return vec3(select(0f, 1f, _e2));
}

fn main_1() {
    var b_2: bool;
    var bv: vec3<bool>;
    var a: vec3<f32>;
    var i: vec2<i32>;
    var u: vec4<u32>;
    var f: f32;

    let _e2 = x_1;
    b_2 = (_e2 > 0i);
    let _e6 = b_2;
    let _e7 = b_2;
    bv = vec3<bool>(_e6, !(_e7), true);
    let _e12 = b_2;
    let _e13 = tint(_e12);
    a = _e13;
    let _e15 = bv;
    i = select(vec2(0i), vec2(1i), _e15.xy);
    let _e23 = b_2;
    u = vec4(select(0u, 1u, _e23));
    let _e29 = bv;
    f = select(0f, 1f, _e29.x);
    let _e35 = a;
    let _e36 = f;
    let _e41 = i;
    let _e42 = vec2<f32>(_e41);
    let _e49 = u;
    o = ((vec4<f32>(_e35.x, _e35.y, _e35.z, _e36) + vec4<f32>(_e42.x, _e42.y, 0f, 0f)) + vec4<f32>(_e49));
    return;
}

@fragment 
fn main(@location(0) @interpolate(flat) x: i32) -> FragmentOutput {
    x_1 = x;
    main_1();
    let _e3 = o;
    return FragmentOutput(_e3);
}
