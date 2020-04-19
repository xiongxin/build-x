const std = @import("std");

const assert = std.debug.assert;
const mem = std.mem;

const warn = std.debug.warn;

pub fn main() void {
  const bytes = "hello";

  warn("\noptional 1\ntype:{} \nvalue: {}, {}\n", .{
    @typeName(@TypeOf(bytes)),
    bytes,
    "\u{1f4a9}\u{1f4aa}\u{1f4ab}a"
  });
}