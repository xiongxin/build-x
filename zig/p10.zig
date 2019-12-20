const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
<<<<<<< HEAD
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
=======
const ArrayList = std.ArrayList;
const fmt = std.fmt;
>>>>>>> master

const FileOpenError = error {
  AccessDenied,
  OutOfMemory,
  FileNotFound,
};

<<<<<<< HEAD

fn foo(err: AllocationError) AllocationError {
    return err;
=======
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
>>>>>>> master
}