use myproject::{Summary, Tweet, NewsArticle };
use std::cmp::PartialOrd;

fn laragest<T: PartialOrd>(list: &[T]) -> &T { // 如果这里不返回引用，而是move里面的值会报错
  let mut max = list.get(0).unwrap();

  for i in list {
    if i > max {
      max = i;
    }
  }

  max
}

pub fn notify(item: impl Summary) {
  println!("Breaking news! {}", item.summarize());
}

fn main() {
  let number_list = vec![34, 50, 25, 100, 65];
  
  println!("the laragest number is {}", laragest(&number_list));

  let tweet = Tweet {
    username: String::from("hourse_ebooks"),
    content: String::from("of course, as you probably already know, people"),
    reply: false,
    retweet: false,
  };

  println!("1 new tweet: {}", tweet.summarize());
  notify(tweet);
  println!("1 new tweet: {}", returns_summarizable(true).summarize());
}


fn returns_summarizable(switch: bool) -> Box<dyn Summary> {
  if switch {
      Box::new(NewsArticle {
          headline: String::from(
              "Penguins win the Stanley Cup Championship!",
          ),
          location: String::from("Pittsburgh, PA, USA"),
          author: String::from("Iceburgh"),
          content: String::from(
              "The Pittsburgh Penguins once again are the best \
               hockey team in the NHL.",
          ),
      })
  } else {
      Box::new(Tweet {
          username: String::from("horse_ebooks"),
          content: String::from(
              "of course, as you probably already know, people",
          ),
          reply: false,
          retweet: false,
      })
  }
}