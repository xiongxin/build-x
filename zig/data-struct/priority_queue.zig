const std = @import("std");
const Allocator = std.mem.Allocator;
const debug = std.debug;
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;

/// Priority queue for storing generic data. Initialize with `init`.
pub fn PriorityQueue(comptime T: type) type {
  return struct {
    const Self = @This();

    items: []T,
    len: usize,
    allocator: *Allocator,
    compareFn: fn (a: T, b: T) bool,


    /// Initialize and return a priority queue. Provide
    /// `compareFn` that returns `true` when its first argument
    /// should get popped before its second argument. For example,
    /// to make `pop` return the minimum value, provide
    ///
    /// `fn lessThan(a: T, b: T) bool { return a < b; }`
    pub fn init(allocator: *Allocator, compareFn: fn (a: T, b: T) bool) Self {
        return Self{
          .items = &[_]T{},
          .len = 0,
          .allocator = allocator,
          .compareFn = compareFn,
        };
    }
  }
}