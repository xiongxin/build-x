const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const ArrayList = std.ArrayList;
const fmt = std.fmt;
const maxInt = std.math.maxInt;


pub fn main() void {
  warn("{} \n", .{@typeInfo(@TypeOf("abc"))});
  warn("{} \n", .{@typeInfo(@TypeOf(12))});

  const a = 12;
  warn("{} \n", .{@typeInfo(@TypeOf(&a))});

  const arr1 = [_]u8 { 81, 82, 83, 84};
  warn("{} \n", .{ arr1[1 .. arr1.len] });
}