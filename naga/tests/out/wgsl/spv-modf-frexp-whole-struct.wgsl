struct Modf32_ {
    member: f32,
    member_1: f32,
}

struct Frexp32_ {
    member: f32,
    member_1: i32,
}

struct Modf64_ {
    member: vec2<f64>,
    member_1: vec2<f64>,
}

struct Frexp64_ {
    member: vec2<f64>,
    member_1: vec2<u32>,
}

fn function_() {
    var local: Modf32_;
    var local_1: Frexp32_;
    var local_2: Modf64_;
    var local_3: Frexp64_;

    let _e6 = modf(1.75f);
    local = Modf32_(_e6.fract, _e6.whole);
    let _e10 = frexp(1.75f);
    local_1 = Frexp32_(_e10.fract, i32(_e10.exp));
    let _e15 = modf(vec2<f64>(1.75lf, 1.75lf));
    local_2 = Modf64_(_e15.fract, _e15.whole);
    let _e19 = frexp(vec2<f64>(1.75lf, 1.75lf));
    local_3 = Frexp64_(_e19.fract, vec2<u32>(_e19.exp));
    return;
}

@compute @workgroup_size(1, 1, 1) 
fn main() {
    function_();
}
