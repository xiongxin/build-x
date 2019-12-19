const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;

pub fn main() void {
  var list = ArrayList(i32).init(allocator);
  defer list.deinit();

  warn("ArrayList[{}]={} \n", .{list.len, list.capacity()});

  var list1 = ArrayList(i32).init(allocator);
  defer list1.deinit();

  warn("ArrayList1[{}]={} \n", .{list1.len, list1.capacity()});

  const ann_list = [_:0]u8 {97,98,99,100};
  for (ann_list) |item, i| {
    warn("ann_list[{}]={} \n", .{i, item});
  }

  // sentinel-terminated arrays
  const array = [_:111]i32 { 1, 2, 3, 4 };
  warn("array \ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(array)),
    array[4],
  });

  var array1 = [_]u8{97,98,99,100};
  warn("array1\ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(&array1)),
    array1,
  });

  var array2 = [_]u8{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
  warn("array1\ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(array2[0..1])),
    (&array2[0]).*,
  });

  const str = "abc";
  const str_bytes = @sliceToBytes(str[0..]);
  warn("array1\ntype: {}\nvalue: {} {} {}\n", .{
    @typeName(@TypeOf(str_bytes)),
    str_bytes[0],
    str_bytes[1],
    str_bytes[2],
  });
}

fn dump(args: var) void {
  assert(args.@"0" == 1234);
  assert(args.@"1" == 12.34);
  assert(args.@"2");
  assert(args.@"3"[0] == 'h');
  assert(args.@"3"[1] == 'i');
}