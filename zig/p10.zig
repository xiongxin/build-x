const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const File = std.fs.File;

pub fn main() void {
  const err = foo(AllocationError.A);
  if (err == error.SomeThing) {
    warn("result \ntype: {}\nvalue: {}\n", .{
      @typeName(@TypeOf(err)),
      err,
    });  
  } else {
    warn("ab", .{});
  }
}

const AllocationError = error {
  SomeThing, A, B
};

const FileOpenError = error {
  AccessDenied,
  OutOfMemory,
  FileNotFound,
};


fn foo(err: AllocationError) AllocationError {
    return err;
}