use redis_protocol::RedisValue;

fn main() {
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
}
