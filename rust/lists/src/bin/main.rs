use lists::first::List;

fn main() {
  let mut list = List::new();

  list.push(12);
  list.push(13);

  println!("{:?}", list);
}