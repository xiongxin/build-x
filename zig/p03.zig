const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;
const fmt = std.fmt;

const Point = struct {
  x: f32,
  y: f32,
};

const Vec3 = struct {
  x: f32,
  y: f32,
  z: f32,

  pub fn init(x: f32, y: f32, z: f32) Vec3 {
    return Vec3 {
      .x = x,
      .y = y,
      .z = z,
    };
  }

  pub fn dot(self: Vec3, other: Vec3) f32 {
    return self.x * other.x + self.y * other.y + self.z * other.z;
  }
};

fn setYBaseOnX(x: *f32, y: f32) void {
  const point = @fieldParentPtr(Point, "x", x);
  point.y = y;
}


fn LinkList(comptime T: type) type {
  return struct {
    pub const Node = struct {
      prev: ?*Node,
      next: ?*Node,
      data: T,
    };

    first: ?*Node,
    last: ?*Node,
    len: usize,
  };
}

const ListOfInts = LinkList(i32);

pub fn main() void {
  var p2 = Point {
    .x = 0.12,
    .y = undefined,
  };

  setYBaseOnX(&p2.x, 100);

  warn("array \ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(p2)),
    p2.y,
  });

  const v1 = Vec3.init(1.0, 1.0, 1.0);
  const v2 = Vec3.init(0.0, 1.0, 0.0);

  warn("v1 and v2 = {} \n", .{ Vec3.dot(v1, v2) });

  var list = ListOfInts {
    .first = null,
    .last  = null,
    .len   = 0,
  };

  var node = ListOfInts.Node {
    .prev = null,
    .next = null,
    .data = 1234,
  };

  list.first = &node;
  list.last  = &node;
  list.len = 1;

  warn("array \ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(list)),
    list,
  });
}