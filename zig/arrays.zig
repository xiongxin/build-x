const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;


const message = [_]u8 { 'h', 'e', 'l', 'l', 'o' };
const message_str = "hello";

pub fn main() void {
  warn("message\ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(message)),
    message,
  });

  warn("message_str\ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(message_str)),
    message_str,
  });

  assert(mem.eql(u8, &message, message_str));

  var sum: usize = 0;
  for (message) |byte| {
    sum += byte;
  }
  warn("sum = {}\n", .{ sum });

  var some_integers: [100]i32 = undefined;
  for (some_integers) |*item, i| {
    item.* = @intCast(i32, i);
  }
  warn("some integers[10] = {}, integers[99] = {}\n", .{ some_integers[10], some_integers[99] });
}