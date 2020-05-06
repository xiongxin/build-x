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