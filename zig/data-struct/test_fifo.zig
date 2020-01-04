const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const ArrayList = std.ArrayList;
const fmt = std.fmt;
const maxInt = std.math.maxInt;
const Buffer = @import("buffer.zig").Buffer;
const LinearFifoBufferType = @import("fifo.zig").LinearFifoBufferType;
const LinearFifo = @import("fifo.zig").LinearFifo;
const allocator = std.heap.page_allocator;
const Fifo = LinearFifo(u8, LinearFifoBufferType.Slice);

pub fn main() void {
  test_fn(.Dynamic);
  var bf = [_]u8{};
  const f = Fifo.init(bf[0..]);
  warn("{}.\n", .{ f });
}

fn test_fn(comptime buffer_type: LinearFifoBufferType) void {
  warn("{}.\n", .{ buffer_type.Dynamic });
}