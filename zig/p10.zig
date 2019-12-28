const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const ArrayList = std.ArrayList;
const fmt = std.fmt;

const FileOpenError = error {
  AccessDenied,
  OutOfMemory,
  FileNotFound,
};

const AllocationError = error {
  OutOfMemory,
};

pub fn main() void {
  const err = foo(AllocationError.OutOfMemory);
  warn("err \ntype: {}\nerr value: {}\n", .{
    @typeName(@TypeOf(err)),
    err,
  });
}

fn foo(err: AllocationError) FileOpenError {
  return err;
}