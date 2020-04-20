const std = @import("std");
const assert = std.debug.assert;

test "namespaced global variable" {
  assert(foo() == 1235);
  assert(foo() == 1235);
}

fn foo() i32 {
  const S = struct {
    var x: i32 = 1234;
  };

  S.x += 1;

  return S.x;
}