const std = @import("std");
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
/// few or no removeal or implementing a LIFO queue. (后进先出(Stack)队列)
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
    pub fn remove(list: *Self, node: *Node) void {
      if (list.first == node) {
        list.first = node.next;
      } else {
        var current_elm = list.first.?;
        while ( current_elm.next != node ) {
          current_elm = current_elm.next.?;
        }

        current_elm.next = node.next;
      }
    }

    /// Remove and return the first node in the list.
    ///
    /// Returns:
    ///   A pointer to the first node in the list.
    pub fn popFirst(list: *Self) ?*Node {
      const first = list.first orelse return null;
      list.first = first.next;
      return first;
    }

    /// Allocate a new node
    /// 
    /// Arguments:
    ///     allocator: Dynamic memory allocator.
    ///
    /// Returns:
    ///     A pointer to the new node
    pub fn allocateNode(list: *Self, allocator: *Allocator) !*Node {
      return allocator.create(Node);
    }

    /// Deallocate a node
    ///
    /// Arguments:
    ///   node: Pointer to the node to dellocate
    ///   allocator: Dynamic memory allocator.
    pub fn destoryNode(list: *Self, node: *Node, allocator: *Allocator) void {
      allocator.destroy(node);
    }

    /// Allocate and initialize a node and its data.
    ///
    /// Arguments:
    ///     data: The data to put inside the node.
    ///     allocator: Dynamic memory allocator.
    ///
    /// Returns:
    ///     A pointer to the new node.
    pub fn createNode(list: *Self, data: T, allocator: *Allocator) !*Node {
      var node = try list.allocateNode(allocator);
      node.* = Node.init(data);
      return node;
    }
  };
}

/// A tail queue is headed by a pair of pointers, one to the head of the
/// list and the other to the tail of the list. The elements are doubly
/// linked so that an arbitrary element can be removed without a need to
/// traverse the list. New elements can be added to the list before or 
/// after anexisting element, at the head of the list, or at the end of 
/// the list. A tail queue may be traversed in either direction.
pub fn TailQueue(comptime T: type) type {
  return struct {
    const Self = @This();

    /// Node inside the linked list wrapping the actual data.
    pub const Node = struct {
      prev: ?*Node,
      next: ?*Node,
      data: T,

      pub fn init(data: T) Node {
        return Node {
          .prev = null,
          .next = null,
          .data = data,
        };
      }
    };


    first: ?*Node,
    last: ?*Node,
    len: usize,

    /// Initialize a linked list.
    /// 
    /// Returns:
    ///     An empty linked list.
    pub fn init() Self {
      return Self{
        .first = null,
        .last  = null,
        .len   = 0,
      };
    }

    /// Insert a new node after an existing one.
    ///
    /// Arguments:
    ///   node: Pointer to a node in the list.
    ///   new_node: Pointer to the new node to insert.
    pub fn insertAfter(list: *Self, node: *Node, new_node: *Node) void {
      new_node.prev = node;
      if (node.next) |next_node| {
        new_node.next = next_node;
        next_node.prev = new_node;
      } else {
        new_node.next = null;
        list.last = new_node;
      }

      node.next = new_node;

      list.len += 1;
    }
  };

  /// Insert a new node before an existing one.
  ///
  /// Arguments:
  ///   node: Pointer to a node in the list.
  ///   new_node: Pointer to the new node to insert.
  pub fn insertBefore(list: *Self, node: *Node, new_node: *Node) void {
    new_node.next = node;
    if (node.prev) |prev_node| {
      new_node.prev = prev_node;
      prev_node.next = new_node;
    } else {
      // First element of the list.
      new_node.prev = null;
      list.first = new_node;
    }

    node.prev = new_node;
    list.len += 1;
  }

  /// Insert a new node at the end of the list
  ///
  /// Arguments:
  ///   new_node: Pointer to the new node to insert.
  pub fn append(list: *Self, new_node: *Node) void {
    if (list.last) |last| {
      list.insertAfter(last, new_node);
    } else {
      // Empty list
      list.prepend(new_node);
    }
  }

  /// Insert a new node at the beginning of the list.
  ///
  /// Arguments
  ///     new_node: Pointer to the new node to insert.

}