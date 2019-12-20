const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const ArrayList = std.ArrayList;
const fmt = std.fmt;

pub fn main() void {
  const a = deferExample();
  warn("a = {} \n", .{ a });

  deferUnwindExample();

  foo(false, 12);

  warn("\ncall2_op = {}\n", .{ do_op(add, 5, 6) });

  var p = Point { .x = 1, .y = 3};
  warn("pfoo() =  {}, p = {}\n", .{ pfoo(&p), p });
}

fn addFortyTwo(x: var) @TypeOf(x) {
  return x + 42;
}

const Point = struct {
  x: i32,
  y: i32,
};

fn pfoo(point: *Point) i32 {
  point.*.x = 1200;
  return point.x + point.y;
}

const call2_op = fn (a: i8, b: i8) i8;
fn do_op(fn_call: call2_op, op1: i8, op2: i8) i8 {
  return fn_call(op1, op2);
}

fn add(a: i8, b: i8) i8 {
  return a + b;
}


fn deferExample() usize {
  var a: usize = 1;
  {
    defer a = 2;
    a = 1;
  }

  assert(a == 2);

  a = 5;
  return a;
}

fn deferUnwindExample() void {
  warn("\n", .{});

  defer {
    warn("1 ", .{});
  }

  defer {
    warn("2 ", .{});
  }

  if (true) {
    // defers are not run if they are never executed.
    defer {
      warn("3 ", .{});
    }
  }
}

fn deferErrorExample(is_error: bool) !void {
  warn("\nstart of function\n", .{});

}


fn foo(condition: bool, b: u32) void {
  const a = if (condition) b else return;
  @panic("do something with a");
}