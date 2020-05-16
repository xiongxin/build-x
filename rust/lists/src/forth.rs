use std::rc::Rc;
use std::cell::{Ref, RefMut, RefCell};

pub struct List<T> {
    head: Link<T>,
    tail: Link<T>,
}

type Link<T> = Option<Rc<RefCell<Node<T>>>>;

struct Node<T> {
    elem: T,
    next: Link<T>,
    prev: Link<T>,
}


impl<T> Node<T> {
    pub fn new(elem: T) -> Rc<RefCell<Self>> {
        Rc::new(RefCell::new(Node {
            elem,
            prev: None,
            next: None
        }))
    }
}

impl<T> List<T> {
    pub fn new() -> Self {
        List { head: None, tail: None }
    }

    pub fn push_front(&mut self, elem: T) {
        let new_head = Node::new(elem);
        match self.head.take() {
            Some(old_node) => {
                old_node.borrow_mut().prev = Some(new_head.clone());
                new_head.borrow_mut().next = Some(old_node);
                self.head = Some(new_head);
            },
            None => {
                self.head = Some(new_head.clone());
                self.tail = Some(new_head);
            }
        }
    }

    pub fn push_back(&mut self, elem: T) {
        let new_head = Node::new(elem);
        match self.tail.take() {
            Some(old_node) => {
                self.tail = Some(new_head.clone());
                new_head.borrow_mut().prev = Some(old_node.clone());
                old_node.borrow_mut().next = Some(new_head);
            },
            None => {
                self.head = Some(new_head.clone());
                self.tail = Some(new_head);
            }
        }
    }

    pub fn pop_front(&mut self) -> Option<T> {
        self.head.take().map(|old_node|{  //
            match old_node.borrow_mut().next.take() { // 老节点的next置空
                Some(new_node) => { // 拿到老节点next的所有权
                    new_node.borrow_mut().prev.take(); // old_node引用计数减一
                    self.head = Some(new_node); // 返回new_node的所有权到List中
                },
                None => {
                    self.tail.take();
                }
            }


            Rc::try_unwrap(old_node).ok().unwrap().into_inner().elem
        })
    }

    pub fn peek_front(&self) -> Option<Ref<T>> {
        self.head.as_ref().map(|node| {
            Ref::map(node.borrow(), |node| &node.elem)
        })
    }
}

impl<T> Drop for List<T> {
    fn drop(&mut self) {
        while self.pop_front().is_some() {}
    }
}

#[cfg(test)]
mod test {
    use super::List;

    #[test]
    fn peek() {
        let mut list = List::new();
        assert!(list.peek_front().is_none());
        list.push_front(1);list.push_front(2);list.push_front(3);

        assert_eq!(&*list.peek_front().unwrap(), &3);
    }
}