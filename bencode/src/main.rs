use std::collections::HashMap;
use anyhow::{Context, Result};
use bencode::BencodeType;
use bencode::Encoder;
use bencode::Decoder;

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
  let mut hm = HashMap::new();
  hm.insert(BencodeType::BtString(String::from("k1")), BencodeType::BtInt(13));
  hm.insert(BencodeType::BtString(String::from("k2")), BencodeType::BtInt(13));
  hm.insert(BencodeType::BtString(String::from("k3")), BencodeType::BtInt(13));
  println!("encoding bt map = {}", Encoder::encode(BencodeType::BtDict(hm)));
  println!("Encod测试=======END")
}


