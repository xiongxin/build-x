#![feature(slice_concat_trait)]
use std::collections::HashMap;
use std::fmt;
use std::hash::Hash;
use std::num::ParseIntError;
use std::str::Chars;
use thiserror::Error;

#[derive(Debug, Clone)]
pub enum BencodeType {
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

pub struct Encoder;

impl Encoder {
  pub fn encode(bt: BencodeType) -> String {
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

pub struct Decoder;

// 自定义错误类型
#[derive(Error, Debug)]
pub enum BencodeError {
  #[error("{0}")]
  DecoderErr(String),

  #[error("数值解析错误")]
  DecodeParseError(#[from] ParseIntError),
}

impl Decoder {
  pub fn decode(&self, bt: &str) -> Result<BencodeType, BencodeError> {
    let mut chars = bt.chars();
    self.decode_chars(&mut chars)
  }

  fn decode_chars(&self, chars: &mut Chars) -> Result<BencodeType, BencodeError> {
    match chars
      .next()
      .ok_or(BencodeError::DecoderErr(format!("解析字符不能为空")))?
    {
      'i' => self.decode_int(chars),
      'l' => self.decode_list(chars),
      'd' => self.decode_dict(chars),
      c => {
        if c.is_ascii_digit() {
          self.decode_str(chars, c.to_digit(10).unwrap())
        } else {
          Err(BencodeError::DecoderErr(format!("无效起始字符串: {}", c)))
        }
      }
    }
  }

  fn decode_str(&self, chars: &mut Chars, len: u32) -> Result<BencodeType, BencodeError> {
    let mut res = String::new();
    let mut len = len;
    while len > 0 {
      res.push(chars.next().ok_or(BencodeError::DecoderErr(format!(
        "字符串长度不够，期望长度为{}",
        len
      )))?);
      len -= 1;
    }

    Ok(BencodeType::BtString(res))
  }

  fn decode_int(&self, chars: &mut Chars) -> Result<BencodeType, BencodeError> {
    let mut res = String::new();

    while let Some(ch) = chars.next() {
      if ch == 'e' {
        break;
      }

      res.push(ch);
    }

    Ok(BencodeType::BtInt(res.parse::<i32>()?))
  }

  fn decode_list(&self, chars: &mut Chars) -> Result<BencodeType, BencodeError> {
    let mut list = Vec::new();

    while let Some(ch) = chars.next() {
      if ch == 'e' {
        break;
      }

      list.push(self.decode_chars(chars)?)
    }

    Ok(BencodeType::BtList(list))
  }

  fn decode_dict(&self, chars: &mut Chars) -> Result<BencodeType, BencodeError> {
    let mut map = HashMap::new();
  }
}
