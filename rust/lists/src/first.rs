#[derive(Debug)]
pub struct List {
  head: Link
}
#[derive(Debug)]
enum Link {
  Empty,
  More(Box<Node>)
}

#[derive(Debug)]
struct Node {
  elem: i32,
  next: Link
}

impl List {
  pub fn new() -> Self {
    List { head: Link::Empty }
  }

  pub fn push(&mut self, elem: i32) {
    let new_node = Node {
      elem,
      next: std::mem::replace(&mut self.head, Link::Empty)
    };

    self.head = Link::More(Box::new(new_node));
  }

  pub fn pop(&mut self) -> Option<i32> {
    match std::mem::replace(&mut self.head, Link::Empty) {
      Link::Empty => None,
      Link::More(node) => {
        self.head = node.next;
        Some(node.elem)
      }
    }
  }
}

impl Drop for List {
  fn drop(&mut self) {
    // 1. 如果 List 的 head 是 Link::Empty
    // 2. 替换所有的 Link节点为 Link::Eempty
    let mut cur_link = std::mem::replace(&mut self.head, Link::Empty);
    // `while let` == "do this thing until this pattern doesn't match"
    while let Link::More(mut boxed_node) = cur_link {
        cur_link = std::mem::replace(&mut boxed_node.next, Link::Empty);
        // boxed_node goes out of scope and gets dropped here;
        // but its Node's `next` field has been set to Link::Empty
        // so no unbounded recursion occurs.
    }
  }
}

#[cfg(test)]
mod test {
  use super::List;

  #[test]
  fn basics() {
    let mut list = List::new();

    assert_eq!(list.pop(), None);

    // Populate list
    list.push(1);
    list.push(2);
    list.push(3);

    assert_eq!(list.pop(), Some(3));
    assert_eq!(list.pop(), Some(2));
    assert_eq!(list.pop(), Some(1));
    assert_eq!(list.pop(), None);
  }
}