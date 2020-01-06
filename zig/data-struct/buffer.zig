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
  pub fn init(allocator: *Allocator, m:[]const u8) !Buffer {
    var self = try initSize(allocator, m.len);
    mem.copy(u8, self.list.items, m);
    return self;
  }

  /// Initialize memory to size bytes of undefined values.
  /// Must deinitialize with deinit.
  pub fn initSize(allocator: *Allocator, size: usize) !Buffer {
    var self = initNull(allocator);
    try self.resize(size);
    return self;
  }

  /// Initialize with capacity to hold at least num bytes.
  /// Must deinitialize with deinit.
  /// 设置底层List capacity
  pub fn initCapacity(allocator: *Allocator, num: usize) !Buffer {
    var self = Buffer{
      .list = try ArrayList(u8).initCapacity(allocator, num + 1),
    };
    self.list.appendAssumeCapacity(0);
    return self;
  }

  /// Must deinitialize with deinit.
  /// None of the other operations are valid until you do one of these:
  /// * ::replaceContents
  /// * ::resize
  pub fn initNull(allocator: *Allocator) Buffer {
    return Buffer{
      .list = ArrayList(u8).init(allocator),
    };
  }

  /// Must deinitialize with deinit.
  pub fn initFromBuffer(buffer: Buffer) !Buffer {
    return Buffer.init(buffer.list.allocator, buffer.toSliceConst());
  }

  /// Buffer takes ownership of the passed in slice. The slice must have been
  /// allocated with `allocator`.
  /// Must deinitialize with deinit.
  pub fn fromOwnedSlice(allocator: *Allocator, slice: []u8) !Buffer {
    var self = Buffer{
      .list = ArrayList(u8).fromOwnedSlice(allocator, slice),
    };
    try self.list.append(0);
    return self;
  }

  /// The caller owns the returned memory. The Buffer becomes null and 
  /// is safe to `deinit`.
  pub fn toOwnedSlice(self: *Buffer) []u8 {
    const allocator = self.list.allocator;
    const result = allocator.shrink(self.list.items, self.len());
    self.* = initNull(allocator);
    return result;
  }

  ///
  pub fn allocPrint(allocator: *Allocator, comptime format: []const u8, args: var) !Buffer {
    const countSize = struct {
      fn countSize(size: *usize, bytes: []const u8) (error{}!void) {
        size.* += bytes.len;
      }
    }.countSize;

    var size: usize = 0;
    std.fmt.format(&size, error{}, countSize, format, args) catch |err| switch (err) {};
    var self = try Buffer.initSize(allocator, size);
    assert((std.fmt.bufPrint(self.list.items, format, args) catch unreachable).len == size);
    return self;
  }

  pub fn deinit(self: *Buffer) void {
    self.list.deinit();
  }

  pub fn toSlice(self: Buffer) [:0]u8 {
    return self.list.toSlice()[0..self.len() : 0];
  }

  pub fn toSliceConst(self: Buffer) [:0]const u8 {
    return self.list.toSliceConst()[0..self.len() : 0];
  }

  pub fn shrink(self: *Buffer, new_len: usize) void {
    assert(new_len <= self.len());
    self.list.shrink(new_len + 1);
    self.list.items[self.len()] = 0;
  }

  /// 扩充cap
  /// Buffer是0结尾的，将list长度设置为new_len + 1
  /// 将字符结尾设置为0
  pub fn resize(self: *Buffer, new_len: usize) !void {
    try self.list.resize(new_len + 1);
    self.list.items[self.len()] = 0;
  }

  pub fn isNull(self: Buffer) bool {
    return self.list.len == 0;
  }

  pub fn len(self: Buffer) usize {
    return self.list.len - 1;
  }

  pub fn capacity(self: Buffer) usize {
    return if (self.list.items.len > 0)
      self.list.items.len - 1
    else
      0;
  }

  pub fn append(self: *Buffer, m: []const u8) !void {
    const old_len = self.len();
    try self.resize(old_len + m.len);
    mem.copy(u8, self.list.toSlice()[old_len..], m);
  }

  pub fn appendByte(self: *Buffer, byte: u8) !void {
    const old_len = self.len();
    try self.resize(old_len + 1);
    self.list.toSlice()[old_len] = byte;
  }

  pub fn eql(self: Buffer, m: []const u8) bool {
    return mem.eql(u8, self.toSliceConst(), m);
  }

  pub fn startsWith(self: Buffer, m: []const u8) bool {
    if (self.len() < m.len) return false;
    return mem.eql(u8, self.list.items[0..m.len], m);
  }

  pub fn endsWith(self: Buffer, m: []const u8) bool {
    const l = self.len(); // 10
    if (l < m.len) return false;
    const start = l - m.len; // 10 - 4 = 6, 6 .. 10
    return mem.eql(u8, self.list.items[start .. l], m);
  }

  pub fn replaceContents(self: *Buffer, m: []const u8) !void {
    try self.resize(m.len);
    mem.copy(u8, self.list.toSlice(), m);
  }
