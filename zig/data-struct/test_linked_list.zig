const std  = @import("std");
const warn = std.debug.warn;
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const SinglyLinkedList = @import("linked_list.zig").SinglyLinkedList;
const fmt = std.fmt;
const maxInt = std.math.maxInt;
const testing = std.testing;
const StackU32 = SinglyLinkedList(u32);

pub fn main() !void {
  const allocator = std.heap.page_allocator;

  var list = StackU32.init();
  _ = list.popFirst();

  var one = try list.createNode(1, allocator);
  list.remove(one);
  var two = try list.createNode(2, allocator);
  var three = try list.createNode(3, allocator);
  var four = try list.createNode(4, allocator);
  var five = try list.createNode(5, allocator);
  defer {
    list.destoryNode(one, allocator);
    list.destoryNode(two, allocator);
    list.destoryNode(three, allocator);
    list.destoryNode(four, allocator);
    list.destoryNode(five, allocator);
  }

  list.prepend(two);
  list.insertAfter(two, five);
  list.prepend(one);
  list.insertAfter(two, three);
  list.insertAfter(three, four);

  // Traverse forwards.
  {
    var it = list.first;
    var index: u32 = 0;
    while (it) |node| : (it = node.next) {
      index += node.data;
    }

    warn("{} \n", .{index});
  }


  warn("{} \n", .{list});
}

