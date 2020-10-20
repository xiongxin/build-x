use anyhow::Result;
use ini_parser::Ini;
use std::fs;

fn main() -> Result<()> {
  let ini_str = fs::read_to_string("test.ini")?;
  let ini = Ini::parse(&ini_str)?;
  println!("{:?}", ini.get_section("author"));
  Ok(())
}
