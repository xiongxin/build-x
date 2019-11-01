const warn = @import("std").debug.warn;

var y: i32 = add(10, x);
const x: i32 = add(12, 34);


pub fn main() void {
    warn("x = {} \n", x);
    warn("y = {} \n", y);
    warn("S.x = {} \n", foo());
    warn("S.x = {} \n", foo());
    warn("S.x = {} \n", foo());
    warn("S.x = {} \n", foo());

    warn("200 * 2 = {} \n", u8(200) *% 2);

    const value: ?u32 = null;
    warn("value = {} \n", value.?);
    
}

fn add(a: i32, b: i32) i32 {
    return a + b;
}

fn foo() i32 {
    const S = struct {
        var z: i32 = 1234; // global variable
    };
    warn("get foo() \n");
    S.z += 1;

    return S.z;
}