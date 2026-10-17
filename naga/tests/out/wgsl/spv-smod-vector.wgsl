struct Data {
    a: vec2<i32>,
    b: vec2<i32>,
    c: vec4<i32>,
    d: i32,
}

@group(0) @binding(0) 
var<storage, read_write> unnamed: Data;

fn main_1() {
    let _e4 = unnamed.a;
    let _e6 = unnamed.b;
    unnamed.a = (_e4 - (vec2<i32>(floor((vec2<f32>(_e4) / vec2<f32>(_e6)))) * _e6));
    let _e16 = unnamed.c;
    unnamed.c = (_e16 - (vec4<i32>(floor((vec4<f32>(_e16) / vec4<f32>(vec4<i32>(3i, 3i, 3i, 3i))))) * vec4<i32>(3i, 3i, 3i, 3i)));
    let _e26 = unnamed.d;
    unnamed.d = (_e26 - (i32(floor((f32(_e26) / f32(7i)))) * 7i));
    return;
}

@compute @workgroup_size(1, 1, 1) 
fn main() {
    main_1();
}
