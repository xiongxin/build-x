// FIFO of fixed size items
// Usually used for e.g. byte buffers

const std = @import("std");
const math = std.math;
const mem = std.mem;
const Allocator = mem.Allocator;
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;

pub const LinearFifoBufferType = union(enum) {
  /// The buffer is internal to the fifo; it is of the specified size.
  Static: usize,
  /// The buffer is passed as a slice to the initialiser.
  Slice,
  /// The buffer is managed dynamically using a `mem.Allocator`.
  Dynamic,
};

pub fn LinearFifo(
  comptime T: type,
  comptime buffer_type: LinearFifoBufferType,
) type {
  const autoalign = false;

  const powers_of_two = switch(buffer_type) {
    .Static => std.math.isPowerOfTwo(buffer_type.Static),
    .Slice  => false, // Any size slice could be passed in
    .Dynamic=> true, // This could be configurable in future
  };

  return struct {
    allocator: if (buffer_type == .Dynamic) *Allocator else void,
    buf: if (buffer_type == .Static) [buffer_type.Static]T else []T,
    head: usize,
    count: usize,

    const Self = @This();

    const SliceSelfArg = if (buffer_type == .Static) *Self else Self;

    usingnamespace switch (buffer_type) {
      .Static => struct {
        pub fn init() Self {
          return Self{
            .allocator = {},
            .buf = undefined,
            .head = 0,
            .count = 0,
          };
        }
      },
      .Slice => struct {
        pub fn init(buf: []T) Self {
          return Self{
            .allocator = {},
            .buf = buf,
            .head = 0,
            .count = 0,
          };
        }
      },
      .Dynamic => struct {
        pub fn init(allocator: *Allocator) Self {
          return Self{
            .allocator= allocator,
            .buf = &[_]T{},
            .head = 0,
            .count = 0,
          };
        }
      }
    };

    pub fn deinit(self: Self) void {
      if (buffer_type == .Dynamic)
        self.allocator.free(self.buf);
    }
  };
}