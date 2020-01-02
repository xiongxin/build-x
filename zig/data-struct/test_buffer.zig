const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const ArrayList = std.ArrayList;
const fmt = std.fmt;
const maxInt = std.math.maxInt;
const Buffer = @import("buffer.zig").Buffer;
const allocator = std.heap.page_allocator;

pub fn main() !void {
  var buffer = try Buffer.init(allocator, "abc");
  var buffer2 = try Buffer.initCapacity(allocator, 10);
  var buffer3 = try Buffer.initFromBuffer(buffer);
  const s = try allocator.alloc(u8, 10);
  var buffer4 = try Buffer.fromOwnedSlice(allocator, s);
  var r = buffer.toOwnedSlice();
  var buffer5 = try Buffer.allocPrint(allocator, "12some thing is.",.{});
  defer {
    buffer.deinit();
    buffer2.deinit();
    buffer3.deinit();
    buffer4.deinit();
    buffer5.deinit();
  }
  warn("buffer = {}. \n",  .{ r.len });
  warn("r = {}. \n",  .{ r });
  warn("buffer3 = {} buffer3. = {}. \n",  .{ buffer3, buffer3.toSliceConst() });
  warn("buffer4 = {} buffer4.cap = {}. \n",  .{ buffer4, buffer4.list.items.len });
  warn("buffer5 = {}. \n",  .{ buffer5 });
}