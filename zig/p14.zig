const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const ArrayList = std.ArrayList;
const fmt = std.fmt;
const unicode = std.unicode;
const fs = std.fs;

pub fn main() !void {
  warn("a.cp={}.\n", .{ unicode.utf8CodepointSequenceLength('a') });
  warn("a.cp={}.\n", .{ unicode.utf8CodepointSequenceLength('在') });

  const dir = fs.cwd();
  try fs.makePath(std.heap.page_allocator, "./data");
  const file = try dir.createFile("./data/file.dat", .{.read=true, .truncate=false});
  try file.seekTo(100);
  try file.outStream().stream.writeIntNative(i32, 100);
  try file.outStream().stream.writeIntNative(i32, 101);
  try file.outStream().stream.write("abcd");
  try file.seekTo(4);
  warn("{} \n", .{file.inStream().stream.readIntNative(i32)});
}