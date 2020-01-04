const std  = @import("std");
const warn = std.debug.warn;
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const ArrayList = @import("array_list.zig").ArrayList;
const fmt = std.fmt;
const maxInt = std.math.maxInt;
const testing = std.testing;

pub fn main() !void {
  const allocator = std.heap.page_allocator;

  var list = try ArrayList(i32).initCapacity(allocator, 1024);
  try list.insert(0, 1);
  try list.insert(1, 2);
  defer list.deinit();

  warn("list.len = {}, list.capacity = {} \n", .{ list.len, list.capacity() });

  var slice = try allocator.alloc(i32, 8);
  warn("slice = {} , slice.length = {} \n", .{slice, slice.len});
  var l2 =  ArrayList(i32).fromOwnedSlice(allocator, slice);
  try l2.insert(0, 1);
  try l2.insert(0, 1);
  warn("l2 = {}, items = {}, capacity={} \n", .{l2, l2.items.len,l2.capacity()});
  for (l2.items) |i, idx| {
    warn("{} = {} \t", .{idx, i});
  }
  warn("\n",.{});
}

test "std.ArrayList.basic" {
  var bytes: [1024]u8 = undefined;
  const allocator = std.heap.page_allocator;

  var list = ArrayList(i32).init(allocator);
  defer list.deinit();

  testing.expectError(error.OutOfBounds, list.setOrError(0, 1));

  {
    var i: usize = 0;
    while( i < 10 ) : ( i += 1) {
      warn("i = {} \n", .{i});
      list.append(@intCast(i32, i + 1)) catch unreachable;
    }
  }

  {
    var i: usize = 0;
    while (i < 10) : (i += 1) {
      testing.expect(list.items[i] == @intCast(i32, i + 1));
    }
  }

  for (list.toSlice()) |v, i| {
    testing.expect(v == @intCast(i32, i + 1));
  }
  
  testing.expect(list.pop() == 10);
  testing.expect(list.len == 9);

  list.appendSlice(&[_]i32 { 1, 2, 3 }) catch unreachable;
  testing.expect(list.len  == 12);
  testing.expect(list.pop() == 3);
  testing.expect(list.pop() == 2);
  testing.expect(list.pop() == 1);
  testing.expect(list.len == 9);

  list.appendSlice(&[_]i32{}) catch unreachable;
  testing.expect(list.len == 9);

  // can only set on indices < self.len
  list.set(7, 33);
  list.set(8, 42);

  testing.expectError(error.OutOfBounds, list.setOrError(9, 99));
  testing.expectError(error.OutOfBounds, list.setOrError(10, 123));

  testing.expect(list.pop() == 42);
  testing.expect(list.pop() == 33);
  testing.expect(mem.eql(u8, "abc",  &[_]u8 { 'a','b','c' }));
  // testing.expectEqual("abc", [_]u8 { 'a','b','c' });


}