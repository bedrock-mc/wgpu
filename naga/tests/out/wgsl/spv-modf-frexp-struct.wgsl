struct Data {
    x: vec2<f32>,
    whole: vec2<f32>,
    y: f32,
    e: i32,
}

struct ResType {
    member: vec2<f32>,
    member_1: vec2<f32>,
}

struct ResType_1 {
    member: f32,
    member_1: i32,
}

@group(0) @binding(0) 
var<storage, read_write> unnamed: Data;

fn main_1() {
    let _e2 = unnamed.x;
    let _e4 = modf(_e2);
    let _e7 = ResType(_e4.fract, _e4.whole);
    unnamed.whole = _e7.member_1;
    unnamed.x = _e7.member;
    let _e12 = unnamed.y;
    let _e14 = frexp(_e12);
    let _e18 = ResType_1(_e14.fract, i32(_e14.exp));
    unnamed.e = _e18.member_1;
    unnamed.y = _e18.member;
    return;
}

@compute @workgroup_size(1, 1, 1) 
fn main() {
    main_1();
}
