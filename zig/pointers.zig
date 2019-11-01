const warn = @import("std").debug.warn;


pub fn main() void {
    var array = [_]u8{1, 2, 3, 4};
    var slice = array[0..2];
    warn("array {} \n", @typeName(@typeOf(array)));
    warn("slice {} \n", @typeName(@typeOf(slice)));
}