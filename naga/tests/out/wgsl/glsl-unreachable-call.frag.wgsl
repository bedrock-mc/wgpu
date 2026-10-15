struct FragmentOutput {
    @location(0) o: vec4<f32>,
}

var<private> v_1: vec3<f32>;
var<private> o: vec4<f32>;

fn early() -> f32 {
    var unused: f32;

    return 1f;
}

fn main_1() {
    var i: i32 = 0i;
    var a: vec3<f32>;

    loop {
        let _e4 = i;
        if !((_e4 < 2i)) {
            break;
        }
        {
            let _e11 = v_1;
            if (_e11.x > 0f) {
                {
                    break;
                }
            }
        }
        continuing {
            let _e8 = i;
            i = (_e8 + 1i);
        }
    }
    let _e15 = early();
    o = vec4(_e15);
    let _e17 = v_1;
    if (_e17.z < 0f) {
        {
            discard;
        }
    } else {
        return;
    }
}

@fragment 
fn main(@location(0) v: vec3<f32>) -> FragmentOutput {
    v_1 = v;
    main_1();
    let _e3 = o;
    return FragmentOutput(_e3);
}
