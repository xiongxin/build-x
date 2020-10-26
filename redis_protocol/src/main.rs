use anyhow::Result;
use redis_protocol::redis_client;
use redis_protocol::RedisValue;
fn main() -> Result<()> {
  println!("{}", RedisValue::RStr("string".to_owned()).encode());
  println!("{}", RedisValue::RInt(100).encode());
  println!("{}", RedisValue::RError("thisiserror".to_owned()).encode());
  println!("{}", RedisValue::RBulkStr("println".to_owned()).encode());
  println!(
    "{}",
    RedisValue::RArray(vec![
      RedisValue::RStr("string".to_owned()),
      RedisValue::RError("thisiserror".to_owned()),
      RedisValue::RBulkStr("println".to_owned())
    ])
    .encode()
  );

  println!("{:?}", RedisValue::decode("$3\r\nabc\r\n")?);

  let arr_str = RedisValue::RArray(vec![
    RedisValue::RStr("string".to_owned()),
    RedisValue::RError("thisiserror".to_owned()),
    RedisValue::RInt(122),
    RedisValue::RBulkStr("println".to_owned()),
  ])
  .encode();
  println!("{}", RedisValue::decode(&arr_str)?);

  let mut rclient = redis_client::Redis::open("127.0.0.1:6379", 5)?;
  let mut args = vec!["a"];
  println!("redis get a = {}", rclient.exec_command("GET", &mut args)?);
  Ok(())
}
