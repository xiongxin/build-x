# A Bad Stack

## 基础数据布局
使用简单的Node enum定义时，考虑有两个元素的list
```rust
pub enum List {
    Empty,
    Elem(i32, Box<List>),
}
```

```
[] = stack
() = heap

[Elem A, ptr] -> (Elem B, ptr) -> (Empty, *junk*)
```
这里有两个关键点需要注意:
- 我们分配了一个Node，但是我们说这不是一个Node
- 并且其中的一个不是分配在heap上面

表面上，他们像是互相取消。我们分配了一个额外的Node，但是这个Node其实是不需要分配的，我们考虑
另外一个内存结构

```
[ptr] -> (Elem A, ptr) -> (Elem B, *null*)
```

这个机构无条件的在heap上分配我们的Node.一个关键的不同点是对于`junk`的不在我们的结构之中了。
什么是`junk`呢？我们需要了解enum的内存

一般，我们有一个enum
```rust
enum Foo {
  D1(T1),
  D2(T2),
  ...
  Dn(Tn),
}
```

Foo需要存储一些数值用户标识不同的enum代表(D1, D2, ...)。这是enum的tag。他将会有足够的
内存空间用于存储最大的T1, T2, ..Tn，加一些额外的空间用户满足内存对齐的要求。

最大的takeaway这里是`Empy`是一个单bit，他需要消费足够的内存用于存储指针和一个元素，因为
它必须时刻准备成为一个`Elem`。因此第一种堆分配的结构一个完全的`junk`，消费一bit大于第二种
结构。

考虑两种结构的下面分离list：
```
layout 1:
[Elem A, ptr] -> (Elem B, ptr) -> (Elem C, ptr) -> (Empty *junk*)

split off C:
[Elem A, ptr] -> (Elem B, ptr) -> (Empty *junk*)
[Elem C, ptr] -> (Empty *junk*)
```

```
layout 2:
[ptr] -> (Elem A, ptr) -> (Elem B, ptr) -> (Elem C, *null*)

split off C:
[ptr] -> (Elem A, ptr) -> (Elem B, *null*)
[ptr] -> (Elem C, *null*)
```

第二种结构调用时仅仅复制B在堆上指针，并将原来的值设置为null。第一种结构最终会实现相同的效果
但是它会在heap上复制C到stack上。合并操作是一个逆向操作。

其中一个好消息是关于linked list是你可以使用元素构造node自身，然后随机释放，而不用移除，
你仅仅需要拨弄指针，填充获取移动的值，第一种结构没有满足这个要求。

我们玩可以考虑第一布局是不好的，我们如何重写我们的List呢？

```rust
enum Foo {
  A,
  B(ContainsANonNullPtr),
}
```
这种特别的enum类型会引入空指针优化，可以节约很多tag需要的空间，如果是A时，指针所有的值为指针地址值。

空指针定义是非常重要的，意味着如&,&mut,Box,Rc,Arc,Vec和其他几个rust中重要的类型，在放入Option之后
rust都会做优化

如果阻止分配额外的junk，使用统一分配，然后使用空指针优化，我们需要更好的分离出来，在有元素时分配另外
一个list。

```rust
pub struct List {
  head: Link,
}

pub enum Link {
  Empty,
  More(Box<Node>),
}


struct Node {
  elem: i32,
  next: Link,
}
```

这样子我们就实现了
- List不会分配额外的junk
- enum使用空指针优化模式
- 所有的元素都同意分配

## New

## Ownership 101

函数参数解析

- self: A value代表真正的Ownship，我们可以做到移动，销毁，修改
- &mut self: 一中可变引用，代表可以临时的排他获取value，但是不是他的own。
- &self： 一种共享引用，临时的分享获取一个value

## Push


## Drop

```rust
pub trait Drop {
  fn drop(&mut self);
}
```

一般情况下如果包含的类型已经实现了Drop，都不需要你去实现Drop，并且也不需要调用drop方法。在我们
的List中，所有的drop操作都是drop它的head，然后可能尝试drop`Box<Node>`。这些都是自动完成的，
但是在我们这里有一个例外，自动drop会有问题。

让我们考虑一个简单的列表：

```
list -> A -> B -> C
```

当list要被drop时，会尝试drop A，再Drop B，再 Drop C。这是一种递归代码，递归代码会出现爆栈的情况。
尾递归可以重复利用函数栈，但是在这里并不是尾递归Drop。

```rust
impl Drop for List {
    fn drop(&mut self) {
        // NOTE: you can't actually explicitly call `drop` in real Rust code;
        // we're pretending to be the compiler!
        self.head.drop(); // tail recursive - good!
    }
}

impl Drop for Link {
    fn drop(&mut self) {
        match *self {
            Link::Empty => {} // Done!
            Link::More(ref mut boxed_node) => {
                boxed_node.drop(); // tail recursive - good!
            }
        }
    }
}

impl Drop for Box<Node> {
    fn drop(&mut self) {
        self.ptr.drop(); // uh oh, not tail recursive!
        deallocate(self.ptr);
    }
}

impl Drop for Node {
    fn drop(&mut self) {
        self.next.drop();
    }
}
```

我们不能在deallocating之后drop Box的内容，所以没有尾递归的优化。所以必须实现迭代drop我们的数据。

```
impl Drop for List {
    fn drop(&mut self) {
        let mut cur_link = mem::replace(&mut self.head, Link::Empty);
        // `while let` == "do this thing until this pattern doesn't match"
        while let Link::More(mut boxed_node) = cur_link {
            cur_link = mem::replace(&mut boxed_node.next, Link::Empty);
            // boxed_node goes out of scope and gets dropped here;
            // but its Node's `next` field has been set to Link::Empty
            // so no unbounded recursion occurs.
        }
    }
}
```
# An Ok Stack

`Option`适合存储所有权，方便之后将所有权转移出去,例如: `Option<String>`

## Peek

```
impl<T> Option<T> {
    pub fn as_ref(&self) -> Option<&T>;
}
```

```
list.peek_mut().map(|&mut value| {
    value = 42
});
```
上面的代码使用模式匹配, `|&mut value|`意思为"参数是一个不可变引用，但是仅复制这个
指针指向的值到value"，如果这里我们使用 `|value|`时，`value`的值将会变成`&mut i32`
我们就可以修改这个`value`了。

### IntoIter

```
pub trait Iterator {
    type Item;
    fn next(&mut self) -> Option<Self::Item>;
}
```

Rust有3中不同的迭代需要实现：

- IntoIter - `T`
- IterMut - `&mut T`
- Iter - `&T`

