
pub trait Summary {   // 可以实现多重继承
  fn summarize_author(&self) -> String;

  fn summarize(&self) -> String {
    format!("(Read more from {}...)", self.summarize_author())
  }
}


pub struct NewsArticle {
  pub headline: String,
  pub location: String,
  pub author: String,
  pub content: String,
}

impl Summary for NewsArticle {
  fn summarize_author(&self) -> String {
    format!("@{}", self.author)
  }

  fn summarize(&self) -> String {
    format!("(Read more from {}...)", self.summarize_author())
  }
}

pub struct Tweet {
  pub username: String,
  pub content: String,
  pub reply: bool,
  pub retweet: bool,
}

impl Summary for Tweet {
  fn summarize_author(&self) -> String {
    format!("@{}", self.username)
  }

  fn summarize(&self) -> String {
    format!("Read more from {}...", self.summarize_author())
  }
}