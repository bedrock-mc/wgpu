struct Data {
    x: vec2<f32>,
    whole: vec2<f32>,
    y: f32,
    e: i32,
}

@group(0) @binding(0) 
var<storage, read_write> unnamed: Data;

fn main_1() {
    let _e2 = unnamed.x;
    let _e4 = modf(_e2);
    unnamed.whole = _e4.whole;
    unnamed.x = _e4.fract;
    let _e9 = unnamed.y;
    let _e11 = frexp(_e9);
    unnamed.e = _e11.exp;
    unnamed.y = _e11.fract;
    return;
}

@compute @workgroup_size(1, 1, 1) 
fn main() {
    main_1();
}
