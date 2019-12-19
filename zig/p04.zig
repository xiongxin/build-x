const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const ArrayList = std.ArrayList;
const fmt = std.fmt;

const ArrayListi32 = ArrayList(i32);

const ComplexTypeTag = enum {
  Ok,
  NotOk,
};

const ComplexType = union(ComplexTypeTag) {
  Ok: u8,
  NotOk: void
};

const c = ComplexTypeTag.Ok;

pub fn main() !void {
  if ( @enumToInt(c) == 0) {
    warn("ok \n", .{});
  }

  const c1 = ComplexType{ .Ok = 42 };
  if ( @as(ComplexTypeTag, c1) == ComplexTypeTag.Ok ) {
    warn("is ok tag \n", .{});
  }

  const c2 = ComplexType{ .NotOk = {} };
  if ( @as(ComplexTypeTag, c2) == ComplexTypeTag.NotOk ) {
    warn("is ok tag \n", .{});
  }

  var str1 = "abc";
  var str2: []const u8 = str1.*[0..];
  warn("str1 \ntype: {}\n str2: {}, type eql = {}\n", .{
    @typeName(@TypeOf(str1)),
    @typeName(@TypeOf(str2)),
    @TypeOf(str1) == @TypeOf(str2)
  });

  var bytes: [1024]u8 = undefined;
  var list = ArrayListi32.init(std.heap.page_allocator);
  defer list.deinit();

  try list.append(1);
  try list.append(1);
  try list.append(2);
  try list.append(3);
  try list.append(4);
  try list.append(5);
  try list.append(6);
  try list.append(7);
  try list.append(1);
  try list.append(2);
  try list.append(3);
  try list.append(4);
  try list.append(5);
  try list.append(6);
  try list.append(7);

  warn("str1 \ntype: {}\n str2: {}\n", .{
    list.len,
    list.capacity(),
  });

  var arr1 = [_]u8 { 1, 2 };
  arr1 = [_]u8 {97,98};

  warn("array \ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(&arr1)),
    arr1,
  });

  var arr2: [10]u8 = undefined;
  const slice = arr2[0..];
  slice[0] = 87;
  warn("array \ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(&arr2)),
    arr2,
  });
}

