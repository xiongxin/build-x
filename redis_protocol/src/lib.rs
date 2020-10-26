use crate::RedisValue::{RArray, RBulkStr, RError, RInt, RStr};
use std::fmt;
use std::hash::{Hash, Hasher};
use std::num::ParseIntError;
use thiserror::Error;

pub mod redis_client;

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
pub enum RedisError {
  #[error("decode error: {0}")]
  DecodeError(String),

  #[error("数组长度解析错误")]
  DecodeArraySizeParseIntError(#[from] ParseIntError),

  #[error("not found \\r\\n, redis format error")]
  DecodeFormatError,
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

  pub fn decode(rv: &str) -> Result<RedisValue, RedisError> {
    Ok(RedisValue::decode_iner(rv)?.0)
  }

  fn decode_iner<'a>(rv: &'a str) -> Result<(RedisValue, &'a str), RedisError> {
    match &rv[0..1] {
      "+" => return RedisValue::decode_str(rv),
      "*" => return RedisValue::decode_arr(rv),
      "-" => return RedisValue::decode_error(rv),
      ":" => return RedisValue::decode_int(rv),
      "$" => return RedisValue::decode_bulk_str(rv),
      _ => return Err(RedisError::DecodeError(format!("格式错误:{}", rv))),
    }
  }

  fn decode_str<'a>(chars: &'a str) -> Result<(RedisValue, &'a str), RedisError> {
    let idx = chars.find(CRLF).ok_or(RedisError::DecodeFormatError)?;

    Ok((
      RedisValue::RStr(chars[1..idx].to_owned()),
      &chars[idx + 2..],
    ))
  }

  fn decode_bulk_str<'a>(chars: &'a str) -> Result<(RedisValue, &'a str), RedisError> {
    let idx = chars.find(CRLF).ok_or(RedisError::DecodeFormatError)?;

    let str_len = chars[1..idx].parse::<usize>()?;
    let start = idx + 2;
    let end = start + str_len;

    Ok((
      RedisValue::RBulkStr(chars[start..end].to_owned()),
      &chars[end + 2..],
    ))
  }

  fn decode_error<'a>(chars: &'a str) -> Result<(RedisValue, &'a str), RedisError> {
    let idx = chars.find(CRLF).ok_or(RedisError::DecodeFormatError)?;

    Ok((
      RedisValue::RError(chars[1..idx].to_owned()),
      &chars[idx + 2..],
    ))
  }

  fn decode_int<'a>(chars: &'a str) -> Result<(RedisValue, &'a str), RedisError> {
    let idx = chars.find(CRLF).ok_or(RedisError::DecodeFormatError)?;

    Ok((RedisValue::RInt(chars[1..idx].parse()?), &chars[idx + 2..]))
  }

  fn decode_arr<'a>(chars: &'a str) -> Result<(RedisValue, &'a str), RedisError> {
    let idx = chars.find(CRLF).ok_or(RedisError::DecodeFormatError)?;

    let mut arr_len = chars[1..idx].parse::<i32>()?;
    let mut res = Vec::new();
    let mut wait_decode_str = &chars[idx + 2..];

    while arr_len > 0 {
      let decode_res = RedisValue::decode_iner(wait_decode_str)?;
      res.push(decode_res.0);
      wait_decode_str = decode_res.1;
      arr_len = arr_len - 1;
    }

    return Ok((RedisValue::RArray(res), &wait_decode_str[2..]));
  }
}
