struct FragmentOutput {
    @location(0) o: vec4<f32>,
}

var<private> i_1: i32;
var<private> o: vec4<f32>;

fn pick(a: u32, b: u32) -> u32 {
    var a_1: u32;
    var b_1: u32;

    a_1 = a;
    b_1 = b;
    let _e4 = a_1;
    let _e5 = b_1;
    return (_e4 + _e5);
}

fn pick_1(a_2: f32, b_2: f32) -> f32 {
    var a_3: f32;
    var b_3: f32;

    a_3 = a_2;
    b_3 = b_2;
    let _e4 = a_3;
    let _e5 = b_3;
    return (_e4 * _e5);
}

fn main_1() {
    var c: u32;
    var m: u32;
    var p: u32;
    var q: f32;

    let _e2 = i_1;
    c = clamp(u32(_e2), 0u, 31u);
    let _e8 = i_1;
    m = max(u32(_e8), 3u);
    let _e13 = i_1;
    let _e16 = pick(u32(_e13), 1u);
    p = _e16;
    let _e18 = i_1;
    let _e21 = pick_1(f32(_e18), 1f);
    q = _e21;
    let _e23 = c;
    let _e25 = m;
    let _e27 = p;
    let _e29 = q;
    o = vec4<f32>(f32(_e23), f32(_e25), f32(_e27), _e29);
    return;
}

@fragment 
fn main(@location(0) @interpolate(flat) i: i32) -> FragmentOutput {
    i_1 = i;
    main_1();
    let _e3 = o;
    return FragmentOutput(_e3);
}
