pub fn main() void {
  foo(12);
}

fn foo(x: i32) void {
  if  (x >= 5) {
    bar(); // 1
  } else {
    bang2();
  }
}

fn bar() void {
  if (baz()) { // 2
    quux();
  } else {
    hello();
  }
}

fn baz() bool {
  return bang1(); // 3
}

fn quux() void {
  bang2();
}

fn hello() void {
  bang2(); // 6
}

fn bang1() bool {
  return false;
}

fn bang2() void {
  @panic("PermissionDenied");
}