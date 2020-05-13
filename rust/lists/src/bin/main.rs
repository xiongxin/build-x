use lists::first::List;
use std::borrow::Cow;

fn main() {
  let mut list = List::new();

  list.push(12);
  list.push(13);

  println!("{:?}", list);

  // let s = String::from("s: &str");

  let mut sc = Cow::from(String::from("s: &str"));
  sc.to_mut().push('a');
  let i: &str = &sc;
  println!("sc = {}", &sc);
  println!("sc = {}", &sc);
  sc.to_mut().push_str("abc");
  println!("sc = {}", &sc);
}