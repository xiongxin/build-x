const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;
const fmt = std.fmt;

pub fn main() !void {
  const str = "abc";
  const arr = &[2:0]u8{1, 2};
  warn("array \ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(str)),
    str[1..2],
  });

  warn("array \ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(arr[0..])),
    &arr[1..2],
  });

  const x: u8 = 12;
  const y: i32 = 12;
  warn("array \ntype: {}\nvalue: {}\n", .{
    @TypeOf(&x).alignment,
    @TypeOf(&y).alignment,
  });

  const s1:[]const u8 = "print a";
  var ptr = s1.ptr;
  //ptr += 3;
  const s2:[]const u8 = s1[5..s1.len];
  warn("s1 \ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(s1.ptr)),
    s2
  });

  var all_together: [100]u8 = undefined;
  const all_together_slice = all_together[0..];
  const h = try fmt.bufPrint(all_together_slice, "{} {}", .{ "a", "b" });
  warn("s1 \ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(h)),
    h
  });

  const array = [_]i32{100, 100};
  const slice = @sliceToBytes(array[0..]);
  for (slice) |item| {
    warn("{} \t", .{ item });
  }
}