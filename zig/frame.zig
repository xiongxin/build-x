const std = @import("std");
const warn= std.debug.warn;

test "heap allocated frame" {
    const frame = try std.heap.direct_allocator.create(@Frame(func));
    frame.* = async func();
}



fn func() void {
    warn("do {}", "abc");
}