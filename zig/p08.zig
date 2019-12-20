const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const ArrayList = std.ArrayList;
const fmt = std.fmt;

const Variant = union(enum) {
  Int: i32,
  Bool: bool,
  // void can be omitted when inferring enum tag type.
  None,

  fn truthy(self: Variant) bool {
    return switch (self) {
      .Int => |x_int| x_int != 0,
      .Bool => |x_bool| x_bool,
      .None => false,
    };
  }
};

pub fn main() void {
  const v1 = Variant { .Int = 123 };
  warn("result \ntype: {}\nvalue: {}\n tagName: {}", .{
    @typeName(@TypeOf(v1)),
    v1,
    @tagName(v1)
  });

  const v2: Variant = .{ .Bool = true };
  warn("result \ntype: {}\nvalue: {}\n tagName: {} \n", .{
    @typeName(@TypeOf(v2)),
    v2.Bool,
    @tagName(v2)
  });

  var y: i32 = 123;
  const x = blk: {
    y += 1;
    break :blk y;
  };

  warn("x = {} \n", .{ x });

  var sum1: u32 = 0;
  numbers_left = 3;
  while (eventuallyNullSequence()) |value| {
    sum1 += value;
  } else |err| {
    warn("err \ntype: {}\nerr value: {}\n", .{
      @typeName(@TypeOf(err)),
      err,
    });
    warn("sum1 = {} \n", .{ sum1 });
  }

  warn("sum1 = {} \n", .{ sum1 });

  var i: i32 = 0;
  while( i < 3 ) : ({ warn("2.current i = {} \n", .{ i }); i += 1;warn("3.current i = {} \n", .{ i }); }) {
    warn("1.current i = {} \n", .{ i });
  } else {
    warn("else 1.current i = {} \n", .{ i });
  }

  const items = [_]i32 { 4, 5, 0, 3, 4 };
  var sum: i32 = 0;
  for (items) |item| {
    if (item == 0) break;
    sum += item;
  }

  warn("sum = {} \n", .{ sum });

  const a = 5;
  const b = 4;
  const result = if (a != b) blk: {
                    break :blk if (a > b) 100000 else 1000;
                  }
                  else 3089;
  warn("result = {} \n", .{ result });

  const a1: ?u32 = 0;
  if (a1) |value| {
    warn("a1 = {} \n", .{a1});
  } else {
    unreachable;
  }
}

var numbers_left: u32 = undefined;
fn eventuallyNullSequence() anyerror!u32 {
  return if (numbers_left == 0) error.ReachedZero else blk: {
    numbers_left -= 1;
    break :blk numbers_left;
  };
}