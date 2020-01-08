const std = @import("std");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;
const mem = std.mem;
const Allocator = mem.Allocator;

/// List of items
///
///
/// This is a wrapper around an array of T values. Initialize with `init`
pub fn ArrayList(comptime T: type) type {
  return AlignedArrayList(T, null);
}

pub fn AlignedArrayList(comptime T: type, comptime alignment: ?u29) type {
  if  (alignment) |a| {
    if (a == @alignOf(T)) {
      return AlignedArrayList(T, null);
    }
  }

  return struct {
    const Self = @This(); // 当前结构

    /// 使用toSlice直接代替slicing,因为如果不指定slice的结束位置
    /// 可能会分配一个未初始化话的内存
    items: Slice,
    len: usize,
    allocator: *Allocator,

    pub const Slice = if (alignment) |a| ([]align(a) T) else []T;
    pub const SliceConst = if (alignment) |a| ([]align(a) const T) else []const T;

    /// 去出初始化使用 `deinit` 或者 `toOwnedSlice`
    pub fn init(allocator: *Allocator) Self {
      return Self {
        .items = &[_]T{}, // 初始化空数组
        .len = 0,
        .allocator = allocator, // 内存分配器
      };
    }

    /// Initialize with capacity to hold at lease num elements.
    /// Deinitialize with `deinit` or use `toOwnedSlice`.
    pub fn initCapacity(allocator: *Allocator, num: usize) !Self {
      var self = Self.init(allocator);
      try self.ensureCapacity(num);
      return self;
    }

    /// 释放所有分配的内存
    pub fn deinit(self: Self) void {
      self.allocator.free(self.items);
    }

    /// 返回内容的slice，仅在list不会变化大小
    pub fn toSlice(self: Self) Slice {
      return self.items[0..self.len];
    }

    /// 返回const slice
    pub fn toSliceConst(self: Self) SliceConst {
      return self.items[0..self.len];
    }

    /// 安全的获取list的第i项
    pub fn at(self: Self, i: usize) T {
      return self.toSliceConst()[i];
    }

    /// 设置第i项的值， 或者返回超出边界的错误
    pub fn setOrError(self: Self, i: usize, item: T) !void {
      if (i >= self.len) return error.OutOfBounds;
      self.items[i] = item;
    }

    /// 
    pub fn set(self: Self, i: usize, item: T) void {
      assert(i < self.len);
      self.items[i] = item;
    }

    /// 不重新分配内存时最大容量
    pub fn capacity(self: Self) usize {
      return self.items.len;
    }

    /// 获取一个slice的所有权，这个slice必须是通过 `allocator`分配的
    /// 去初始化使用 `deinit` or `toOwnedSlice`
    pub fn fromOwnedSlice(allocator: *Allocator, slice: Slice) Self {
      return Self {
        .items = slice,
        .len   = slice.len,
        .allocator = allocator,
      };
    }

    /// 调用者获取返回的内存，ArrayList变成空
    pub fn toOwnedSlice(self: *Self) Slice {
      const allocator = self.allocator;
      const result = allocator.shrink(self.items, self.len); // 返回老的 slice
      self.* = init(allocator);
      return result;
    }

    /// Insert `item` at index `n`. Moves `list[n .. list.len]`
    /// to make room.
    pub fn insert(self: *Self, n: usize, item: T) !void {
      try self.ensureCapacity(self.len + 1);
      self.len += 1;
      mem.copyBackwards(T, self.items[n + 1 .. self.len], self.items[n .. self.len - 1]);
      self.items[n] = item;
    }

    /// Insert slice `items` at index `n`.
    /// Moves `list[n .. list.len]` to make room.
    pub fn insertSlice(self: *Self, n: usize, items: SliceConst) !void {
      try self.ensureCapacity(self.len + items.len);
      self.len += items.len;

      mem.copyBackwards(T, self.items[n + items.len .. self.len], self.items[n .. self.len - items.len]);
      mem.copy(T, self.items[n .. n + items.len], items);
    }

    /// Extend the list by 1 element. Allocates more memory as necessary.
    pub fn append(self: *Self, item: T) !void {
      const new_item_ptr = try self.addOne();
      new_item_ptr.* = item;
    }

    /// Extend the list by 1 element, but asserting `self.capacity`
    /// is sufficient to hold an additional item.
    pub fn appendAssumenCapacity(self: *Self, item: T) void {
      const new_item_ptr = self.addOneAssumeCapacity();
      new_item_ptr.* = item;
    }

    /// Remove the element at index `i` from the list and return
    /// its value. Asserts the array has at least one item.
    pub fn orderedRemove(self: *Self, i: usize) T {
      const newlen = self.len - 1;
      if (newlen == i) return self.pop(); // 如果是最后一个元素，弹出他

      const old_item = self.at(i);
      for (self.items[i .. newlen]) |*b, j| {
        b.* = self.items[i + 1 + j];
      }
      self.items[newlen] = undefined;
      self.len = newlen;
      return old_item;
    }

    /// Removes the element at specified index and return it.
    /// The empty slot is filled from the end of the list.
    pub fn swapRemove(self: *Self, i: usize) T {
      if (self.len - 1 == i) return self.pop();

      const slice = self.toSlice();
      const old_item = slice[i];
      slice[i] = self.pop();

      return old_item;
    }

    /// Removes the element at the specified index and returns it
    /// or an error.OutOfBounds is returned. If no error then
    /// the empty slot is filled from the end of the list.
    pub fn swapRemoveOrError(self: *Self, i: usize) !T {
      if (i >= self.len) return error.OutOfBounds;
      return self.swapRemove(i);
    }

    /// Append the slice of items to the list.
    /// Allocates more memory as necessary.
    pub fn appendSlice(self: *Self, items: SliceConst) !void {
      try self.ensureCapacity(self.len + items.len);
      mem.copy(T, self.items[self.len .. ], items);
      self.len += items.len;
    }

    /// Adjust the list's length to `new_len`. Doesn't initialize
    /// added items if any.
    pub fn resize(self: *Self, new_len: usize) !void {
      try self.ensureCapacity(new_len);
      self.len = new_len;
    }

    // Reduce allocated capacity to `new_len`.
    pub fn shrink(self: *Self, new_len: usize) void {
      assert(new_len <= self.len);
      self.len = new_len;
      self.items = self.allocator.realloc(self.items, new_len) catch |e|
        switch (e) {
          error.OutOfMemory => return, // no problem, capacity is still correct then.
        };
    }

    /// remove last item
    pub fn pop(self: *Self) T {
      self.len -= 1;
      return self.items[self.len];
    }

    pub fn popOrNull(self: *Self) ?T {
      if (self.len == 0) return null;
      return self.pop();
    }

    /// Increase length by 1, returning pointer to the new item.
    pub fn addOne(self: *Self) !*T {
      try self.ensureCapacity(self.len + 1); // 确保内存足够
      return self.addOneAssumeCapacity();  // 返回最后一个位置的指针
    }

    // 长度加一，容量不变
    pub fn addOneAssumeCapacity(self: *Self) *T {
      assert(self.len < self.capacity());
      const result = &self.items[self.len];
      self.len += 1;
      return result;
    }

    /// 确保容量满足
    pub fn ensureCapacity(self: *Self, new_capacity: usize) !void {
      var better_capacity = self.capacity();
      if (better_capacity >= new_capacity) return;
      while (true) {
        better_capacity += better_capacity / 2 + 8;
        if (better_capacity >= new_capacity) break;
      }

      self.items = try self.allocator.realloc(self.items, better_capacity);
    }
  };
}