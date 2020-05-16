extern crate clap;

use clap::{App};
fn main() {
    let matches = App::new("App1")
        .version("1.0")
        .author("xiongxin")
        .about("Does awesome things")
        .arg("-c, --config=[FILE] 'Sets a custom config file'") // 可选命令
        .arg("<output1> 'Sets an optional output file'") // 必须要提供的命令
        .arg("<output2> 'Sets an optional output file'") // 必须要提供的命令
        .arg("-d... 'Turn debugging information on'") // 一个或多个 -ddd
        .subcommand(
            App::new("test")
                .about("does testing things")
                .arg("-l, --list 'lists test values'"),
        )
        .get_matches();

    if let Some(o) = matches.value_of("output1") {
        println!("Value for output1: {}", o);
    }

    if let Some(o) = matches.value_of("output2") {
        println!("Value for output2: {}", o);
    }

    if let Some(c) = matches.value_of("config") {
        println!("Value for config: {}", c);
    }

    match matches.occurrences_of("d") {
        0 => println!("Debug mode if off"),
        1 => println!("Debug mode is kind of on"),
        2 => println!("Debug mode is on"),
        _ => println!("Don't be crazy"),
    }

    // 子命令

    if let Some(matches) = matches.subcommand_matches("test") {
        if matches.is_present("list") {
            println!("Printing testing lists....")
        } else {
            println!("Not printing testing lists...")
        }
    }
}
