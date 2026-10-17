struct FragmentOutput {
    @location(0) o: vec4<f32>,
}

var<private> v_1: vec4<f32>;
var<private> o: vec4<f32>;

fn split(x: f32, whole: ptr<function, f32>, acc: ptr<function, f32>) {
    var x_1: f32;

    x_1 = x;
    let _e4 = x_1;
    (*whole) = floor(_e4);
    let _e6 = (*acc);
    let _e7 = x_1;
    let _e8 = (*whole);
    (*acc) = (_e6 + (_e7 - _e8));
    return;
}

fn main_1() {
    var parts: vec4<f32> = vec4(0f);
    var m: mat2x2<f32> = mat2x2<f32>(vec2<f32>(1f, 0f), vec2<f32>(0f, 1f));
    var local: f32;
    var local_1: f32;
    var local_2: f32;
    var local_3: f32;
    var local_4: f32;
    var local_5: f32;

    let _e11 = v_1;
    let _e16 = parts.w;
    local_1 = _e16;
    split(_e11.x, (&local), (&local_1));
    let _e18 = local;
    parts.y = _e18;
    let _e19 = local_1;
    parts.w = _e19;
    let _e20 = v_1;
    let _e31 = m[0i][1i];
    local_3 = _e31;
    split(_e20.y, (&local_2), (&local_3));
    let _e33 = local_2;
    m[1i][0i] = _e33;
    let _e34 = local_3;
    m[0i][1i] = _e34;
    let _e35 = v_1;
    let _e44 = m[1i][1i];
    local_5 = _e44;
    split(_e35.z, (&local_4), (&local_5));
    let _e46 = local_4;
    parts[2i] = _e46;
    let _e47 = local_5;
    m[1i][1i] = _e47;
    let _e48 = parts;
    let _e50 = m[0];
    let _e52 = m[1];
    o = (_e48 + vec4<f32>(_e50.x, _e50.y, _e52.x, _e52.y));
    return;
}

@fragment 
fn main(@location(0) v: vec4<f32>) -> FragmentOutput {
    v_1 = v;
    main_1();
    let _e3 = o;
    return FragmentOutput(_e3);
}
