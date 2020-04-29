use std::io::prelude::*;
use std::net::TcpListener;
use std::net::TcpStream;
use std::fs;

fn main() {
    let listener = TcpListener::bind("127.0.0.1:7878").unwrap();

    for stream in listener.incoming() {
        let stream = stream.unwrap();
        handle_connection(stream);
    }
}


fn handle_connection(mut stream: TcpStream) {

    let mut buffer = [0; 1024];
    let mut vec = Vec::new();
    while let Ok(size) = stream.read(&mut buffer) {
        let str: String = String::from_utf8_lossy(&buffer).to_owned().to_string();
        vec.extend_from_slice(&buffer);
        if size < 1024 || str.contains("\r\n\r\n")  {  // 如果再次读取长度小于1024 或者读取到了\r\n时终止
            break;
        }

        buffer = [0; 1024];
    }
    let str: String = String::from_utf8_lossy(&vec).to_owned().to_string();
    println!("最终的请求数据: {}", str);
    let contents = fs::read_to_string("hello.html").unwrap();

    let response = format!("HTTP/1.1 200 OK\r\n\r\n{}", contents);

    if let Err(foo) = stream.write_all(response.as_bytes()) {
        println!("write_all error: {}", foo);
    } 

    if let Err(err) = stream.flush() {
        println!("flush error: {}", err);
    }

}