const std = @import("std");
const warn = std.debug.warn;
const mem = std.mem;

const message = [_]u8{'h','e','l','l','o'};



const same_message = "hello";

pub fn main() void {
    var sum: usize = 0;
    for (message) |byte| {
        sum += byte;
    }

    warn("sum = {}", sum);

    var some_integers: [100]i32 = undefined;
    for (some_integers) |*item, i| {
        item.* = @intCast(i32, i);
    }
    warn("some_integer {}", some_integers[100]);
}