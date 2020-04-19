const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const ArrayList = std.ArrayList;
const fmt = std.fmt;
const maxInt = std.math.maxInt;
const fs = std.fs;

const S = struct {
  slice: []u8,
};

const S1 = struct {
  a: i32,
};

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
  var s1 = S1 {
    .a = 122,
  };

  var s2 = &s1;

  s2.* = S1 {
    .a = 1222,
  };

  warn("message_str\ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(s2)),
    s2,
  });

  var list = [_]i32 {1, 2, 3, 4, 5, 6, 7, 8};
  var l1 = list[0..4];
  var l2 = list[1..5];
  list[0] = 10000;

  warn("{},{}.\n", .{l1[0], l2[0]});
}