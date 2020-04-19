const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const ArrayList = std.ArrayList;
const fmt = std.fmt;
const maxInt = std.math.maxInt;
const fs = std.fs;

pub fn main() !void {
  const file = try fs.createFileAbsolute("/home/xiongxin/Code/build-x/zig/test.dat", .{.read=true, .truncate=false});
  // const position = file.inStream().stream.readIntNative(i32) catch 0;
  // warn("{} \n", .{position});
  // try file.seekTo(@intCast(u64, position));
  try file.outStream().stream.writeIntNative(i32, 100);
  try file.outStream().stream.writeIntNative(i32, 101);
  try file.outStream().stream.write("abcd");
  try file.seekTo(4);
  warn("{} \n", .{file.inStream().stream.readIntNative(i32)});

  warn("array \ntype: {}\nvalue: {}\n", .{
    getTrivialEqlFn(i32),
    getTrivialEqlFn(i32)(1, 2),
  });
}

pub fn getTrivialEqlFn(comptime K: type) (fn (K, K) bool) {
  return struct {
    fn eql(a: K, b: K) bool {
      return a == b;
    }
  }.eql;
}