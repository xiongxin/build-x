const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const File = std.fs.File;


pub fn main() !void {
  const file = try File.openRead("./p01.zig");
  defer file.close();
  var buf:[1024]u8= undefined;
  const all_together_slice = buf[0..];
  const getEndPos = try file.getEndPos();
  warn("getEndPos\ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(getEndPos)),
    getEndPos,
  });
  try file.seekTo(0);
  var read_length = try file.read(all_together_slice);
  warn("message_str\ntype: {}\nvalue: {}\n", .{
      @typeName(@TypeOf(all_together_slice)),
      all_together_slice,
  });
  while( read_length != 0 ) {
    read_length = try file.read(all_together_slice);
    warn("message_str\ntype: {}\nvalue: {}\n", .{
      @typeName(@TypeOf(all_together_slice[0..read_length])),
      all_together_slice[0..read_length],
    });
  }
}