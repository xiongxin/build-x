const std = @import("std");
const debug = std.debug;
const mem = std.mem;
const Allocator = mem.Allocator;
const assert = debug.assert;
const testing = std.testing;
const ArrayList = std.ArrayList;

/// A buffer that allocates memory and maintains a null byte at the end.
pub const Buffer = struct {
  list: ArrayList(u8),

  /// Must deinitialize with deinit.
  pub fn init(allocator: *Allocator, m: []const u8) !Buffer {
    var self = try initSize(allocator, m.len);
    mem.copy(u8, self.list.items, m);
    return self;
  }

  /// Initialize memory to size bytes of undefined values.
  /// Must deinitialize with deinit.
  pub fn initSize(allocator, *Allocator, size: usize) !Buffer {
    var self = initNull(allocator);
    try self.resize(size);
    return self;
  }

  /// Must deinitialize with deinit
  /// None of the other operations are vaild until you do one of these:
  /// * ::replaceContents
  /// * ::resize
  pub fn initNull(allocator: *Allocator) Buffer {
    return Buffer{ .list = ArrayList(u8).init(allocator) };
  }

  /// Initialize with capacity to hold at least num bytes.
  /// Must deinitialize with deinit.
  pub fn initCapacity(allocator: *Allocator, num: usize) !Buffer {
    
  }
}