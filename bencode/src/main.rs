#![feature(slice_concat_trait)]
use std::collections::HashMap;
use std::fmt;
use std::hash::Hash;

fn main() {
  println!("结构测试=============START");
  println!("{}", BencodeType::BtString(String::from("s: &str")));
  println!("{}", BencodeType::BtInt(123));
  println!(
    "{}",
    BencodeType::BtList(vec![
      BencodeType::BtString(String::from("s: &str")),
      BencodeType::BtInt(123)
    ])
  );

  let mut hm = HashMap::new();
  hm.insert(
    BencodeType::BtString(String::from("s: &str1")),
    BencodeType::BtString(String::from("s: &str")),
  );

  hm.insert(
    BencodeType::BtString(String::from("s: &str2")),
    BencodeType::BtString(String::from("s: &str")),
  );
  hm.insert(
    BencodeType::BtString(String::from("s: &str3")),
    BencodeType::BtString(String::from("s: &str")),
  );
  hm.insert(
    BencodeType::BtString(String::from("s: &str4")),
    BencodeType::BtString(String::from("s: &str")),
  );
  println!("{}", BencodeType::BtDict(hm));
  println!("结构测试=============END");

  println!("Encod测试=======START");
  let bt = BencodeType::BtList(vec![
    BencodeType::BtString(String::from("abc")),
    BencodeType::BtInt(123),
  ]);
  println!("encoding bt = {}", Encoder::encode(bt));
  println!("Encod测试=======START")
}

#[derive(Debug, Clone)]
enum BencodeType {
  BtString(String),
  BtInt(i32),
  BtList(Vec<BencodeType>),
  BtDict(HashMap<BencodeType, BencodeType>),
}

impl Eq for BencodeType {}
impl PartialEq<BencodeType> for BencodeType {
  fn eq(&self, other: &BencodeType) -> bool {
    match self {
      BencodeType::BtString(s1) => match other {
        BencodeType::BtString(s2) => s1 == s2,
        _ => false,
      },
      BencodeType::BtInt(i1) => match other {
        BencodeType::BtInt(i2) => i1 == i2,
        _ => false,
      },
      BencodeType::BtList(v1) => match other {
        BencodeType::BtList(v2) => v1 == v2,
        _ => false,
      },
      BencodeType::BtDict(d1) => match other {
        BencodeType::BtDict(d2) => {
          if d1.len() != d2.len() {
            return false;
          } else {
            for (k, v) in d1 {
              if !d2.contains_key(&k) {
                return false;
              } else {
                if v != d2.get(&k).unwrap() {
                  return false;
                }
              }
            }
          }

          return true;
        }
        _ => false,
      },
    }
  }
}

impl Hash for BencodeType {
  fn hash<H>(&self, state: &mut H)
  where
    H: std::hash::Hasher,
  {
    match self {
      BencodeType::BtString(s) => s.hash(state),
      BencodeType::BtInt(i) => i.hash(state),
      BencodeType::BtList(v) => v.hash(state),
      BencodeType::BtDict(d) => {
        for (k, v) in d {
          k.hash(state);
          v.hash(state);
        }
      }
    }
  }
}
impl fmt::Display for BencodeType {
  fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
    match self {
      BencodeType::BtString(s) => write!(f, "<Bencode {}>", s),
      BencodeType::BtInt(i) => write!(f, "<Bencode {}>", i),
      BencodeType::BtList(v) => write!(f, "<Bencode {:?}>", v),
      BencodeType::BtDict(d) => write!(f, "<Bencode {:?}>", d),
    }
  }
}

struct Encoder;

impl Encoder {
  fn encode(bt: BencodeType) -> String {
    match bt {
      BencodeType::BtString(s) => format!("{}:{}", s.len(), s),
      BencodeType::BtInt(i) => format!("i{}e", i),
      BencodeType::BtList(v) => {
        let mut res = String::from("l");
        for bt_itm in v {
          res += &Self::encode(bt_itm);
        }
        res += "e";
        res
      }
      BencodeType::BtDict(d) => {
        let mut res = String::from("d");
        for (k, v) in d {
          res += &Self::encode(k);
          res += &Self::encode(v);
        }
        res += "e";
        res
      }
    }
  }
}

struct Decoder;
