

const std = @import("std");
const warn = std.debug.warn;

pub fn main() void {
  
  var a: u32 = @as(u32, std.math.maxInt(u32));
  a +%= 1;
  warn("a +% b = {}, a +%= b,and a = {} \n", .{ @as(u32, std.math.maxInt(u32)) +% 1 , a});
}