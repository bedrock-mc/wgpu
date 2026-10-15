struct FragmentOutput {
    @location(0) o: vec4<f32>,
}

var<private> v_1: vec2<i32>;
var<private> u_1: u32;
var<private> o: vec4<f32>;

fn main_1() {
    var a: vec2<i32>;
    var b: vec2<i32>;
    var c: vec3<u32>;
    var d: vec3<u32>;

    let _e3 = v_1;
    a = (_e3 % vec2(4i));
    let _e9 = v_1;
    b = (vec2(7i) % _e9);
    let _e13 = u_1;
    c = (vec3(_e13) % vec3(3u));
    let _e20 = u_1;
    d = (vec3(9u) % vec3(_e20));
    let _e25 = a;
    let _e26 = b;
    let _e27 = vec2<f32>(_e25);
    let _e30 = vec2<f32>(_e26);
    let _e34 = c;
    let _e35 = vec3<f32>(_e34);
    let _e42 = d;
    let _e43 = vec3<f32>(_e42);
    o = ((vec4<f32>(_e27.x, _e27.y, _e30.x, _e30.y) + vec4<f32>(_e35.x, _e35.y, _e35.z, 0f)) + vec4<f32>(_e43.x, _e43.y, _e43.z, 0f));
    return;
}

@fragment 
fn main(@location(0) @interpolate(flat) v: vec2<i32>, @location(1) @interpolate(flat) u: u32) -> FragmentOutput {
    v_1 = v;
    u_1 = u;
    main_1();
    let _e5 = o;
    return FragmentOutput(_e5);
}
