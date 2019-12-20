const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const ArrayList = std.ArrayList;
const fmt = std.fmt;
const maxInt = std.math.maxInt;

const FileOpenError = error {
  AccessDenied,
  OutOfMemory,
  FileNotFound,
};

const AllocationError = error {
  OutOfMemory,
};

pub fn main() !void {
  const err = foo(AllocationError.OutOfMemory);
  warn("err \ntype: {}\nerr value: {}\n", .{
    @typeName(@TypeOf(err)),
    err,
  });

  const result = try parseU64("1234", 10);
  warn("result = {} \n", .{result});

  _ = try foo1(true);
  //warn("r1 = {} \n", .{r1});
}

fn foo(err: AllocationError) FileOpenError {
  return err;
}

pub fn foo1(a: bool) !i32 {
  if (a) {
    try foo2();
    return 12;
  } else {
    return error.MyError;
  }
}

fn foo2() !void {
  return error.D;
}

pub fn parseU64(buf: []const u8, radix: u8) !u64 {
  var x: u64 = 0;
  for (buf) |c| {
    const digit = charToDigit(c);

    if (digit >= radix) {
      return error.InvalidChar;
    }

    // x *= radix
    if (@mulWithOverflow(u64, x, radix, &x)) {
      return error.Overflow;
    }

    // x += digit
    if (@addWithOverflow(u64, x, digit, &x)) {
      return error.Overflow;
    }
  }

  return x;
}

fn charToDigit(c: u8) u8 {
  return switch (c) {
    '0' ... '9' => c - '0',
    'A' ... 'Z' => c - 'A' + 10,
    'a' ... 'z' => c - 'a' + 10,
    else => maxInt(u8),
  };
}