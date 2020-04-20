const assert = @import("std").debug.assert;
const mem = std.mem;
const std = @import("std");
const warn = std.debug.warn;
pub fn main() void {

  var message = [_]u8{ 'h', 'e', 'l', 'l', 'o' };


  std.debug.warn("message {}\n", .{mem.toBytes(message)[1]});

  for (message) |*item| {
    std.debug.warn("item {x}\n", .{item});
    std.debug.warn("item {}\n", .{item.*});
  }

  var some_integers: [100]i32 = undefined;
  for (some_integers) |*item, i| {
    item.* = @intCast(i32, i);
  }

  warn("some_integers[10] = {}, some_integers[99] = {}\n", .{ some_integers[10], some_integers[99] });

  // 使用编译时代码初始化数组
  var fancy_array = init: {
    var initial_value: [10]Point = undefined;
    for (initial_value) |*pt, i| { // 拿到pt的指针位置
      pt.* = Point {
        .x = @intCast(i32, i),
        .y = @intCast(i32, i) * 2,
      };
    }
    break :init initial_value;
  };

  warn("fancy_array[4].x = {}, fancy_array[4].y = {}\n", .{ fancy_array[4].x, fancy_array[4].y });

  var array: [4]u8 = .{11, 22, 33, 44};

  dump1(.{ @as(u32, 1234), @as(f64, 12.34) });
  //  dump2(.{ @as(u8, 11), @as(u8, 22) });
  dump2(&array);

  const array1 = [_:1]u8 {1, 2, 3, 4};
  assert(@TypeOf(array1) == [4:1]u8);
  warn("arra1.len = {}, array1[len] = {}\n", .{ array1.len, array1[array1.len] });
}

const Point = struct {
  x: i32,
  y: i32,
};

fn dump1(args: var) void {
  assert(args.@"0" == 1234);
  assert(args.@"1" == 12.34);
}

fn dump2(args: []u8) void {
  assert(args.len == 4);
}