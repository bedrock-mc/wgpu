struct Output {
    result: vec3<f32>,
    sizes: array<f32, 2>,
}

var<workgroup> shared_values: array<array<vec3<f32>, 9>, 4>;
@group(0) @binding(0) 
var<storage, read_write> global: Output;

fn sum(values: array<vec3<f32>, 9>) -> vec3<f32> {
    var values_1: array<vec3<f32>, 9>;
    var total: vec3<f32> = vec3(0f);
    var i: i32 = 0i;

    values_1 = values;
    loop {
        let _e7 = i;
        if !((_e7 < 9i)) {
            break;
        }
        {
            let _e14 = total;
            let _e15 = i;
            let _e17 = values_1[_e15];
            total = (_e14 + _e17);
        }
        continuing {
            let _e11 = i;
            i = (_e11 + 1i);
        }
    }
    let _e19 = total;
    return _e19;
}

fn main_1() {
    var local_values: array<array<vec3<f32>, 9>, 2>;
    var nested: array<array<f32, 3>, 2>;

    local_values[1i][8i] = vec3(1f);
    nested[1i][2i] = 2f;
    let _e19 = shared_values[3];
    let _e20 = sum(_e19);
    let _e22 = local_values[1];
    let _e23 = sum(_e22);
    global.result = (_e20 + _e23);
    global.sizes[0i] = 49f;
    let _e33 = nested[1][2];
    global.sizes[1i] = (23f + _e33);
    return;
}

@compute @workgroup_size(1, 1, 1) 
fn main() {
    main_1();
    return;
}
