use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 3 {
        panic!("参数错误");
    }

    let config = parse_config(&args);
    println!("Searching for {}", config.query);
    println!("In file {}", config.filename);

    let contents = fs::read_to_string(config.filename).expect("读取文件内存出错");

}

#[derive(Debug)]
struct Config {
    query: String,
    filename: String,
}

fn parse_config(args: &[String]) -> Config {
    Config {
        query: args[1].clone(),
        filename: args[2].clone(),
    }
}

fn testS(s: String) {
    println!("{}", s);
}

fn testC(s: Config) {
    println!("{:?}", s);
}
