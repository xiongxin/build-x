use crate::RedisValue;
use std::io;
use std::io::Read;
use std::io::Write;
use std::net::AddrParseError;
use std::net::SocketAddr;
use std::net::TcpStream;
use std::time;
use thiserror::Error;

pub struct Redis {
  socket: TcpStream,
  connected: bool,
  pub timeout: u64,
  pub pipeline: Vec<RedisValue>,
}

#[derive(Error, Debug)]
pub enum RedisError {
  #[error("redis open error: {0}")]
  OpenError(#[from] io::Error),

  #[error("addr parse error")]
  AddrParseError(#[from] AddrParseError),
}

impl Redis {
  pub fn open(addr: &str, timeout: u64) -> Result<Redis, RedisError> {
    let tcp = TcpStream::connect_timeout(
      &addr.parse::<SocketAddr>()?,
      time::Duration::new(timeout, 0),
    )?;

    Ok(Redis {
      socket: tcp,
      connected: true,
      timeout,
      pipeline: Vec::new(),
    })
  }

  pub fn exec_command<'a>(&mut self, command: &'a str, args: &mut Vec<&'a str>) -> RedisValue {
    args.insert(0, command);
    let mut cmdValues = Vec::new();
    for arg in args {
      cmdValues.push(RedisValue::RBulkStr(String::from(*arg)));
    }

    let arr = RedisValue::RArray(cmdValues);
    let _ = self.socket.write(arr.encode().as_bytes());

    RedisValue::RBulkStr("aa".to_owned())
  }
}
