const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;

pub fn main() void {
  const ann_list = .{ @as(u32, 1234), @as(f64, 12.34), true, "hi"};
  dump(ann_list);

  warn("message_str\ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(ann_list)),
    ann_list.@"2",
  });

  // sentinel-terminated arrays
  const array = [_:111]i32 { 1, 2, 3, 4 };
  warn("array \ntype: {}\nvalue: {}\n", .{
    @typeName(@TypeOf(array)),
    array[4],
  });

  var array1 = [_]u8{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
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

  _ = std.c.printf("Hello, world!\n"); // OK

  const msg = "Hello, world!\n";
  const non_null_terminated_msg: [msg.len]u8 = msg.*;
  _ = std.c.printf(&non_null_terminated_msg);
}

fn dump(args: var) void {
  assert(args.@"0" == 1234);
  assert(args.@"1" == 12.34);
  assert(args.@"2");
  assert(args.@"3"[0] == 'h');
  assert(args.@"3"[1] == 'i');
}