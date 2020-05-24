extern crate serde;
extern crate toml;

#[macro_use]
extern crate failure;
#[macro_use]
extern crate serde_derive;

use failure::_core::str::FromStr;
use std::collections::HashMap;
use std::path::PathBuf;

use failure::Error;
use std::fs::File;
use std::io::Read;

// 一个新的错误类型,代表toolchain无效
// 自定义derive Fail,实现Fail和Display
// 无需其他的魔法
#[derive(Debug, Fail)]
enum ToolchainError {
    #[fail(display="invalid toolchain name: {}", name)]
    InvalidToolchainName {
        name: String,
    },
    #[fail(display="unknow toolcahin version:{}", version)]
    UnknownToolchainVersion{
        version: String
    }
}

#[derive(Debug)]
pub struct ToolchainId {
    id: String
}

pub fn read_toolchains(path: PathBuf) -> Result<ToolchainId, Error> {
    let mut string = String::new();
    File::open(path)?.read_to_string(&mut string)?;

    if string.contains("abc") {
        return Err(Error::from(ToolchainError::InvalidToolchainName {name: String::from("abd")}));
    }

    let res = ToolchainId {
        id: string
    };

    Ok(res)
}

fn main() -> Result<(), Error> {
    read_toolchains(PathBuf::from("/home/xiongxin/Code/build-x/rust/sample/failure_demo/src/tool.txt"))
        .map_err(|s| {println!("错误:{}", s)});

    Ok(())
}
