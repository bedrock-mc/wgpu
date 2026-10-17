struct FragmentOutput {
    @location(0) o: vec4<f32>,
}

var<private> v_1: vec4<f32>;
var<private> o: vec4<f32>;

fn main_1() {
    var a: bool;
    var b: bool;
    var c: vec3<bool>;
    var d: vec4<bool>;

    let _e2 = v_1;
    a = ((bitcast<u32>(_e2.x) & 0x7fffffffu) > 0x7f800000u);
    let _e6 = v_1;
    b = ((bitcast<u32>(_e6.y) & 0x7fffffffu) == 0x7f800000u);
    let _e10 = v_1;
    c = ((bitcast<vec3<u32>>(_e10.xyz) & vec3(0x7fffffffu)) > vec3(0x7f800000u));
    let _e14 = v_1;
    d = ((bitcast<vec4<u32>>(_e14) & vec4(0x7fffffffu)) == vec4(0x7f800000u));
    let _e17 = a;
    let _e21 = b;
    let _e25 = c;
    let _e30 = d;
    o = vec4<f32>(select(0f, 1f, _e17), select(0f, 1f, _e21), select(0f, 1f, any(_e25)), select(0f, 1f, all(_e30)));
    return;
}

@fragment 
fn main(@location(0) v: vec4<f32>) -> FragmentOutput {
    v_1 = v;
    main_1();
    let _e3 = o;
    return FragmentOutput(_e3);
}
