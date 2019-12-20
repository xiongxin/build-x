const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const File = std.fs.File;

const ComplexType = union(enum) {
  Ok: u8,
  NotOk: void
};

pub fn main() void {

  warn("{} \n",  .{ @typeName(@TagType(ComplexType)) });

  const c = ComplexType{
    .Ok = 42,
  };


  switch (c) {
    .Ok => |val| warn("{} \n", .{ val }),
    .NotOk => unreachable,
  }

  warn("{} \n", .{ c == .Ok });

  const c1 = .Ok;

  switch (c) {
    .Ok => |val| warn("{} \n", .{ val }),
    .NotOk => unreachable,
  }

  warn("{} \n", .{ @typeName((@TypeOf(c1))) });
}