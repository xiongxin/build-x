const std = @import("std.zig");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;
const mem = std.mem;
const Allocator = mem.Allocator;

/// A singly-linked list is headed by a single forward pointer. The elements
/// are singly linked for minimum space and pointer manipulation overhead at
/// the expense of O(n) removal for arbitrary elements. New elements can be
/// added to the list after an existing element or at the head of the list.
/// A singly-linked list may only be traversed in the forward direction.
/// Singly-linked lists are ideal for applications with large datasets and
/// few or no removeal or implementing a LIFO queue. (后进先出队列)
pub fn SinglyLinkedList(comptime T: type) type {
  return struct {
    const Self = @This();

    /// Node inside the linked list wrapping the actual data.
    pub const Node = struct {
      next: ?*Node,
      data: T,

      pub fn init(data: T) Node {
        return Node {
          .next = null,
          .data = data,
        };
      }

      /// Insert a new node after the current one.
      ///
      /// Arguments:
      ///   new_node: Pointer to the new node to insert/
      pub fn insertAfter(node: *Node, new_node: *Node) void {
        new_node.next = node.next;
        node.next = new_node;
      }

      /// Remove a node from the list.
      ///
      /// Arguments:
      ///   node: Pinter to the node to be removed
      /// Returns:
      ///   node removed
      pub fn removeNext(node: *Node) ?*Node {
        const next_node = node.next orelse return null; // node.next为null时，返回null
        node.next = next_node.next;
        return next_node;
      }
    };

    first: ?*Node,

    /// Initialize a link list.
    ///
    /// Returns:
    ///   An empty linked list.
    pub fn init() Self {
      return Self {
        .first = null,
      };
    }

    /// Insert a new node after an existing one
    ///
    /// Arguments:
    ///   node: Pointer to a node in the list.
    ///   new_node: Pointer to the new node to insert.
    pub fn insertAfter(list: *Self, node: *Node, new_node: *Node) void {
      node.insertAfter(new_node);
    }

    /// Insert a new node at the head.
    ///
    /// Arguments:
    ///   new_node: Pointer to the new node to insert.
    pub fn prepend(list: *Self, new_node: *Node) void {
      new_node.next = list.first;
      list.first = new_node;
    }

    /// Remove a node from the list.
    ///
    /// Arguments:
    ///   node: Pointer to the node to be removed.
  }
}