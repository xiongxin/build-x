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

  var a: i32 = 12;
  warn("{} \n", .{@typeInfo(@TypeOf(&a))});

  const arr1 = [_]u8 { 81, 82, 83, 84};
  warn("{} \n", .{ arr1[1 .. arr1.len] });
  var d: ?i32 = 12;
  const b: ?*i32 = &a;
  const c: *?i32 = &d;

  warn("{} \n", .{@typeInfo(@TypeOf(b))});
  warn("{} \n", .{@typeInfo(@TypeOf(c))});
}