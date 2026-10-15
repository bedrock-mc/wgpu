struct Output {
    result: array<f32>,
}

var<workgroup> values: array<f32, 64>;
@group(0) @binding(0) 
var<storage, read_write> global: Output;
var<private> gl_LocalInvocationIndex_1: u32;
var<private> gl_WorkGroupID_1: vec3<u32>;

fn main_1() {
    var i: u32;
    var stride: u32 = 32u;

    let _e4 = gl_LocalInvocationIndex_1;
    i = _e4;
    let _e6 = i;
    let _e8 = i;
    values[_e6] = f32(_e8);
    workgroupBarrier();
    loop {
        let _e12 = stride;
        if !((_e12 > 0u)) {
            break;
        }
        {
            let _e19 = i;
            let _e20 = stride;
            if (_e19 < _e20) {
                {
                    let _e22 = i;
                    let _e24 = i;
                    let _e26 = values[_e24];
                    let _e27 = i;
                    let _e28 = stride;
                    let _e31 = values[(_e27 + _e28)];
                    values[_e22] = (_e26 + _e31);
                }
            }
            workgroupBarrier();
        }
        continuing {
            let _e16 = stride;
            stride = (_e16 >> 1u);
        }
    }
    let _e33 = i;
    if (_e33 == 0u) {
        {
            let _e37 = gl_WorkGroupID_1;
            let _e41 = values[0];
            global.result[_e37.x] = _e41;
            return;
        }
    } else {
        return;
    }
}

@compute @workgroup_size(64, 1, 1) 
fn main(@builtin(local_invocation_index) gl_LocalInvocationIndex: u32, @builtin(workgroup_id) gl_WorkGroupID: vec3<u32>) {
    gl_LocalInvocationIndex_1 = gl_LocalInvocationIndex;
    gl_WorkGroupID_1 = gl_WorkGroupID;
    main_1();
    return;
}
