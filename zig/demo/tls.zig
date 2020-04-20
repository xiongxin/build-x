const std = @import("std");
const assert = std.debug.assert;
const warn = std.debug.warn;

threadlocal var x: i32 = 1234;

test "thread local storage" {
  warn("主线程线程ID = {} \n", .{std.Thread.getCurrentId()});
  const thread1 = try std.Thread.spawn({}, testTls);
  const thread2 = try std.Thread.spawn({}, testTls);

  // testTls({});
  thread1.wait();
  thread2.wait();
}

fn testTls(context: void) void {
  assert(x == 1234);
  x += 1;
  assert(x == 1235);
  warn("当前线程ID = {} \n", .{std.Thread.getCurrentId()});
}