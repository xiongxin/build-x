use crate::RedisValue::{RArray, RBulkStr, RError, RInt, RStr};
use std::fmt;
use std::hash::{Hash, Hasher};
use thiserror::Error;

const CRLF: &'static str = "\r\n";
const REDISNIL: &'static str = "\0\0";

#[derive(Debug, Eq)]
pub enum RedisValue {
  RStr(String),
  RError(String),
  RInt(i32),
  RBulkStr(String),
  RArray(Vec<RedisValue>),
}

impl fmt::Display for RedisValue {
  fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
    match self {
      RStr(s) => write!(f, "{}", s),
      RBulkStr(s) => write!(f, "{}", s),
      RInt(i) => write!(f, "{}", i),
      RError(s) => write!(f, "{}", s),
      RArray(arr) => write!(f, "{:?}", arr),
    }
  }
}

impl Hash for RedisValue {
  fn hash<H: Hasher>(&self, state: &mut H) {
    match self {
      RStr(s) => s.hash(state),
      RBulkStr(s) => s.hash(state),
      RInt(i) => i.hash(state),
      RError(s) => s.hash(state),
      RArray(arr) => arr.hash(state),
    }
  }
}

impl PartialEq<RedisValue> for RedisValue {
  fn eq(&self, other: &RedisValue) -> bool {
    match self {
      RStr(s1) => {
        if let RStr(s2) = other {
          s1 == s2
        } else {
          false
        }
      }
      RBulkStr(s1) => {
        if let RBulkStr(s2) = other {
          s1 == s2
        } else {
          false
        }
      }
      RInt(s1) => {
        if let RInt(s2) = other {
          s1 == s2
        } else {
          false
        }
      }
      RError(s1) => {
        if let RError(s2) = other {
          s1 == s2
        } else {
          false
        }
      }
      RArray(s1) => {
        if let RArray(s2) = other {
          s1 == s2
        } else {
          false
        }
      }
    }
  }
}

#[derive(Debug, Error)]
enum RedisValueError {
  #[error("decode error: {0}")]
  DecodeError(String),
}

impl RedisValue {
  pub fn encode(&self) -> String {
    match self {
      RStr(s) => format!("+{}{}", s, CRLF),
      RError(s) => format!("-{}{}", s, CRLF),
      RInt(i) => format!(":{}{}", i, CRLF),
      RBulkStr(s) => format!("${}{}{}{}", s.len(), CRLF, s, CRLF),
      RArray(arr) => {
        let mut res = String::new();
        res.push_str(&format!("*{}{}", arr.len(), CRLF));
        for item in arr {
          res.push_str(&item.encode());
        }
        res.push_str(CRLF);
        res
      }
    }
  }

  pub fn decode(rv: &str) -> RedisValue {}
}
