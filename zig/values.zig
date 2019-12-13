const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;

pub fn main() void {
  // integers
  const one_plus_one: i32 = 1 + 1;
  warn("{}\n", .{ @typeName(@TypeOf(one_plus_one)) });
  warn("{}\n", .{one_plus_one});

  const seven_div_three: f32 = 7.0 / 3.0;
  warn("{}\n", .{ @typeName(@TypeOf(seven_div_three)) });

  warn("{}\n{}\n{}\n", .{
    true and false,
    true or false,
    !true,
  });

  var option_value: ?[]const u8 = null;
  warn("\noptional 1\ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(option_value)),
    option_value,
  });
  option_value = "abc";
  warn("\noptional 1\ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(option_value)),
    option_value,
  });

  var number_or_error: anyerror!i32 = error.ArgNotFound;
  warn("\noptional 1\ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(number_or_error)),
    number_or_error,
  });

  number_or_error = 1234;
  warn("\noptional 1\ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(number_or_error)),
    number_or_error,
  });

  const str = "abc";
  warn("\noptional 1\ntype: {}\ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(str)),
    @typeName(@TypeOf(str.*)),
    str.*.len,
  });

  warn("str: {}\n", .{str[3]});

  const c = 'c';
  warn("\noptional 1\ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(c)),
    c,
  });

  warn("\noptional 1\ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(foo())),
    foo(),
  });

  G.g += 1;
  warn("\namespaced global variable 1\ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(G.g)),
    G.g,
  });

  var x: i32 = 1;
  comptime var y: i32 = 1;

  x += 1;
  y += 1;

  warn("\nivide type: {}\n", .{
    3 /% 0
  });
}

const G = struct {
  var g: i32 = 1;
};

// namespaced global variable
fn foo() i32 {
  const S = struct {
    var x: i32 = 1234;
  };

  S.x += 1;
  return S.x;
}

fn divide(a: i32, b: i32) i32 {
  return a / b;
}