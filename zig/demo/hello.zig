const warn = @import("std").debug.warn;


const std = @import("std");

pub fn main() void {
  warn("Hello, world!\n", .{});
}