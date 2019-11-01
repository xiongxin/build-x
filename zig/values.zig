const warn = std.debug.warn;
const std = @import("std");
const os = std.os;

pub fn main() void {
    // integers
    const one_plus_one: i32 = 1 + 1;
    warn("1 + 1 = {} \n", one_plus_one);

    var optional_value: ?[]const u8 = null;
    optional_value = "hi";
    warn("\noptional l\ntype: {}\nvalue:{}\n",
        @typeName(@typeOf(optional_value)), optional_value);

    var number_or_error: anyerror!i32 = error.ArgNotFound;
    number_or_error = 12;
    warn("\nerror union l\ntype:{}\nvalue:{}\n",
        @typeName(@typeOf(number_or_error)), number_or_error);
}