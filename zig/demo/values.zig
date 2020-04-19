const std = @import("std");

const warn = std.debug.warn;
const os = std.os;
const assert = std.debug.assert;

pub fn main() void {

  
  // optional
  var optional_value: ?[]const u8 = null;
  assert(optional_value == null);

  warn("\noptional 1\ntype:{} \nvalue: {}\n", .{
    @typeName(@TypeOf(optional_value)),
    optional_value
  });

  optional_value = "hi";
  warn("\noptional 1\ntype:{} \nvalue: {}\n", .{
    @typeName(@TypeOf(optional_value)),
    optional_value
  });


  var number_or_error: anyerror!i32 = error.ArgNotFound;

  warn("\noptional 1\ntype:{} \nvalue: {}\n", .{
    @typeName(@TypeOf(number_or_error)),
    number_or_error
  });

  number_or_error = 1234;

  warn("\noptional 1\ntype:{} \nvalue: {}\n", .{
    @typeName(@TypeOf(number_or_error)),
    number_or_error
  });
}