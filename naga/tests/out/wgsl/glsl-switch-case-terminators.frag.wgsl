struct FragmentOutput {
    @location(0) o: vec4<f32>,
}

var<private> sel_1: i32;
var<private> o: vec4<f32>;

fn pick(s: i32) -> vec4<f32> {
    var s_1: i32;

    s_1 = s;
    let _e2 = s_1;
    switch _e2 {
        case 0, 1: {
            return vec4(1f);
        }
        case 2: {
            return vec4(2f);
        }
        default: {
            return vec4(0f);
        }
    }
}

fn main_1() {
    var i: i32 = 0i;

    let _e2 = sel_1;
    let _e3 = pick(_e2);
    o = _e3;
    loop {
        let _e6 = i;
        if !((_e6 < 4i)) {
            break;
        }
        {
            let _e13 = i;
            switch _e13 {
                case 1: {
                    let _e15 = o;
                    o.x = (_e15.x + 1f);
                    continue;
                }
                case 2: {
                    let _e20 = o;
                    o.y = (_e20.y + 1f);
                }
                default: {
                    let _e25 = o;
                    o.z = (_e25.z + 1f);
                }
            }
        }
        continuing {
            let _e10 = i;
            i = (_e10 + 1i);
        }
    }
    let _e29 = sel_1;
    switch _e29 {
        case 3: {
            let _e30 = o;
            o = (_e30 * 2f);
            discard;
        }
        default: {
            return;
        }
    }
}

@fragment 
fn main(@location(0) @interpolate(flat) sel: i32) -> FragmentOutput {
    sel_1 = sel;
    main_1();
    let _e3 = o;
    return FragmentOutput(_e3);
}
