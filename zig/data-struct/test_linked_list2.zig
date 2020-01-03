const std  = @import("std");
const warn = std.debug.warn;
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const TailQueue = @import("linked_list.zig").TailQueue;
const fmt = std.fmt;
const maxInt = std.math.maxInt;
const testing = std.testing;
const QueueU32 = TailQueue(u32);


pub fn main() void {
  const a = 100;
  warn("{},{}.\n", .{ mem.toBytes(&a),"a" });
  var q32 = QueueU32.init();
  var n1 = QueueU32.Node.init(1);
  var n2 = QueueU32.Node.init(2);
  var n3 = QueueU32.Node.init(3);
  q32.append(&n1);
  q32.append(&n2);
  q32.append(&n3);
  q32.remove(&n1);
  warn("{}.\n", .{q32});
}