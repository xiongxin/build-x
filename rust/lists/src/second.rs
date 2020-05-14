#[derive(Debug)]
pub struct List<T> {
  head: Link<T>
}

type Link<T> = Option<Box<Node<T>>>;

#[derive(Debug)]
struct Node<T> {
  elem: T,
  next: Link<T>
}

impl<T> List<T> {
  pub fn new() -> Self {
    List { head: None }
  }

  pub fn peek(&self) -> Option<&T> {
    self.head.as_ref().map(|node| &node.elem)
  }

  pub fn peek_mut(&mut self) -> Option<&mut T> {
    self.head.as_mut().map(|node| &mut node.elem)
  }

  pub fn push(&mut self, elem: T) {
    let new_node = Node {
      elem,
      next: self.head.take()
    };

    self.head = Some(Box::new(new_node));
  }

  pub fn pop(&mut self) -> Option<T> {
    self.head.take().map(|node| {
      self.head = node.next;
      node.elem
    })
  }

  pub fn into_iter(self) -> IntoIter<T> {
    IntoIter(self)
  }
}

pub struct IntoIter<T>(List<T>);

impl<T> Iterator for IntoIter<T> {
  type Item = T;
  fn next(&mut self) -> Option<Self::Item> {
    self.0.pop()
  }
}

pub struct Iter<'a, T> {
  next: Option<&'a Node<T>>,
}

impl<'a, T> List<T> {
  pub fn iter(&self) -> Iter<T> {
    Iter { next: self.head.as_ref().map(|node| &**node) }
  }
}

impl<'a, T> Iterator for Iter<'a, T> {
  type Item = &'a T;

  fn next(&mut self) -> Option<Self::Item> {
    self.next.map(|node| {
      self.next = node.next.as_ref().map(|node| &**node);
      &node.elem
    })
  }
}

pub struct IterMut<'a, T> {
  next: Option<&'a mut Node<T>>,
}

impl<'a, T> List<T> {
  pub fn iter_mut(&mut self) -> IterMut<T> {
    IterMut { next: self.head.as_mut().map(|node| &mut **node) } // 3
  }
}

impl<'a, T> Iterator for IterMut<'a, T> {
  type Item = &'a mut T;

  fn next(&mut self) -> Option<Self::Item> {
    self.next.take().map(|node| {
        self.next = node.next.as_mut().map(|node| &mut **node); // self.next = 2
        &mut node.elem
    })
  }
}


impl<T> Drop for List<T> {
  fn drop(&mut self) {
    // 1. 如果 List 的 head 是 Link::Empty
    // 2. 替换所有的 Link节点为 Link::Eempty
    let mut cur_link = self.head.take();
    // `while let` == "do this thing until this pattern doesn't match"
    while let Some(mut boxed_node) = cur_link {
        cur_link = boxed_node.next.take();
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

    assert_eq!(list.peek(), None);
    assert_eq!(list.peek_mut(), None);

    // Populate list
    list.push(1);
    list.push(2);
    list.push(3);

    assert_eq!(list.peek(), Some(&3));
    assert_eq!(list.peek_mut(), Some(&mut 3));

    list.peek_mut().map(|item| {
      *item = 12;
    });
    assert_eq!(list.peek(), Some(&12));
  }

  #[test]
  fn into_iter() {
    let mut list = List::new();
    list.push(1);list.push(2);list.push(3);

    let mut iter = list.into_iter();
    assert_eq!(iter.next(), Some(3));
    assert_eq!(iter.next(), Some(2));
    assert_eq!(iter.next(), Some(1));
    assert_eq!(iter.next(), None);
  }

  #[test]
    fn iter_mut() {
        let mut list = List::new();
        list.push(1); list.push(2); list.push(3);

        let mut iter = list.iter_mut();
        assert_eq!(iter.next(), Some(&mut 3));
        assert_eq!(iter.next(), Some(&mut 2));
        assert_eq!(iter.next(), Some(&mut 1));

        assert_eq!(list.pop(), Some(3));
        assert_eq!(list.peek(), Some(&2));
    }
}