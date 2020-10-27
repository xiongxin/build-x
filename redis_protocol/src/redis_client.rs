use crate::RedisValue;
use crate::CRLF;
use std::io;
use std::io::prelude::*;
use std::net::AddrParseError;
use std::net::SocketAddr;
use std::net::TcpStream;
use std::num::ParseIntError;
use std::string::FromUtf8Error;
use std::time;
use thiserror::Error;

pub struct RedisClient {
  socket: TcpStream,
  connected: bool,
  pub timeout: u64,
  pub pipeline: Vec<RedisValue>,
}

#[derive(Error, Debug)]
pub enum RedisClientError {
  #[error("redis open error: {0}")]
  OpenError(#[from] io::Error),

  #[error("redis host addr parse error")]
  AddrParseError(#[from] AddrParseError),

  #[error("utf8 error")]
  FromUtf8Error(#[from] FromUtf8Error),

  #[error("bulk string len parse error")]
  BulkLenIntParserError(#[from] ParseIntError),

  #[error("redis value decode error")]
  RedisDecodeError(#[from] super::RedisError),
}

type Result<T> = std::result::Result<T, RedisClientError>;

impl RedisClient {
  pub fn open(addr: &str, timeout: u64) -> Result<RedisClient> {
    let tcp = TcpStream::connect_timeout(
      &addr.parse::<SocketAddr>()?,
      time::Duration::new(timeout, 0),
    )?;

    Ok(RedisClient {
      socket: tcp,
      connected: true,
      timeout,
      pipeline: Vec::new(),
    })
  }

  pub fn exec_command<'a>(
    &mut self,
    command: &'a str,
    args: &mut Vec<&'a str>,
  ) -> Result<RedisValue> {
    args.insert(0, command);
    let mut cmd_values = Vec::new();
    for arg in args {
      cmd_values.push(RedisValue::RBulkStr(String::from(*arg)));
    }

    let arr = RedisValue::RArray(cmd_values);
    self.socket.write(arr.encode().as_bytes())?;
    self.socket.flush()?;
    let form = self.read_from()?;
    Ok(RedisValue::decode(&form)?)
  }

  fn read_from(&mut self) -> Result<String> {
    let mut form = self.receive_managed(1)?;
    match &form[..] {
      "+" => {
        form = form + &self.read_stream(CRLF)?;
      }
      "-" => {
        form = form + &self.read_stream(CRLF)?;
      }
      ":" => {
        form = form + &self.read_stream(CRLF)?;
      }
      "$" => {
        let bulk_len: i32 = self.read_stream(CRLF)?.trim().parse()?;
        form = format!("{}{}{}", form, bulk_len, CRLF);
        if bulk_len == -1 {
          form = form + CRLF;
        } else {
          form = form + &self.read_many(bulk_len as usize)?;
          form = form + &self.read_stream(CRLF)?;
        }
      }
      "*" => {
        let arr_len: usize = self.read_stream(CRLF)?.trim().parse()?;
        form = format!("{}{}", form, arr_len);
        for _ in 1..arr_len {
          form = form + &self.read_from()?;
        }
      }
      _ => {}
    }

    Ok(form)
  }

  fn read_many(&mut self, count: usize) -> Result<String> {
    if count == 0 {
      return Ok(String::from(""));
    }
    Ok(self.receive_managed(count)?)
  }

  fn receive_managed(&mut self, size: usize) -> Result<String> {
    let mut buffer = vec![0; size];
    self.socket.read(&mut buffer)?;
    Ok(String::from_utf8(buffer)?)
  }

  fn read_stream(&mut self, break_after: &str) -> Result<String> {
    let mut data = String::new();
    loop {
      if data.ends_with(break_after) {
        break;
      }
      data = data + &self.receive_managed(1)?;
    }
    Ok(data)
  }
}
