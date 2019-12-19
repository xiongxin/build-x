const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const ArrayList = std.ArrayList;
const fmt = std.fmt;


const Type = enum {
  Ok,
  NotOk,
  a,
  b,
  c,
  d,
  e,
  f,
  g, 
  h,
  i,
  j,
  k,
};

const Color = enum {
  Auto,
  Off,
  On,
};

const Payload = union {
  Int: i64,
  Float: f64,
  Bool: bool,
};

const S = struct {
  payload: Payload,
};

const Variant = union(enum) {
  Int: i32,
  Bool: bool,
  // void can be omitted when inferring enum tag type.
  None,

  fn truthy(self: Variant) bool {
    return switch (self) {
      Variant.Int => |x_int| x_int != 0,
      Variant.Bool => |x_bool| x_bool,
      Variant.None => false,
    };
  }
};

pub fn main() void {
  warn("type.ok = {}, type.notok = {}, tagType = {}\n", 
    .{ @enumToInt(Type.Ok), @enumToInt(Type.NotOk), @typeName(@TagType(Type)) });

  const color1: Color = .Auto;

  const result = switch (color1) {
    .Auto => false,
    .On   => true,
    .Off  => false,
  };

  warn("result \ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(result)),
    result,
  });

  const s = S {
    .payload = Payload { .Int = 1234 },
  };
  s.payload = Payload { .Float = 12.34 };
  warn("result \ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(s)),
    s.payload.Float,
  });

  

  var v1 = Variant { .Int = 1 };
  var v2 = Variant { .Bool = false };
  warn("tagType: {} \ntype: {}\nvalue: {}\n", .{
    @typeName(@TagType(Variant)),
    @typeName(@TypeOf(v1)),
    v1,
  });
}