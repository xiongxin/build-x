const std = @import("std");
const assert = std.debug.assert;

test "comptime vars" {
  var x: i32 = 1;
  comptime var y: i32 = 1;

  x += 1;
  y += 1;

  assert(x == 2);
  assert(y == 2);

  if (y != 2) {
    // 这个编译错误不会触发，因为y时一个编译时变量
    // 所以 y != 2也是一个编译时的值， 在语法分析的时候就会作为程序静态执行
    @compileError("wrong y value");
  }
}