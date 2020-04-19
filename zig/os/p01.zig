const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const File = std.fs.File;
const heap = std.heap;
const BufMap = std.BufMap;

pub fn main() !void {
  warn("hello world (pid: {})\n", .{ os.linux.getpid() });

  const rc = try os.fork();
  if (rc < 0) {
    warn("fork failed\n", .{});
    os.exit(1);
  } else if (rc == 0) {
    os.close(os.STDOUT_FILENO);
    _ = try os.open("./p01.output", os.O_CREAT | os.O_WRONLY | os.O_TRUNC, os.S_IRWXU);
    var bufmap = BufMap.init(std.heap.page_allocator);
    defer bufmap.deinit();
    const args = [_][]const u8 { "wc", "p01.zig" };
    switch (os.execvpe(std.heap.page_allocator, &args, &bufmap)) {
      else => {
        warn("脚本执行错误1\n", .{});
        os.exit(1);
      },
      error.OutOfMemory => {
        warn("脚本执行错误2\n", .{});
        os.exit(1);
      }
    }
    warn("hello, I'm child (pid: {})\n", .{ os.linux.getpid() });
  } else {
    const rc_wait = os.waitpid(rc, 0);
    // parent goes down this path (main)
    warn("hello, I'm parent of {} (pid: {})\n", .{ rc, os.linux.getpid() });
  }
}