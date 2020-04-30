pub type List = Option<Node>;

struct Node {
  elem: i32,
  next: List
}

impl List {
  pub fn new() -> Self {
    None
  }
}