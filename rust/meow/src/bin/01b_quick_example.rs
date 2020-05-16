use clap::clap_app;

fn main() {
    let matches =  clap_app!(myapp =>
        (version: "1.0")
        (author: "xiongxin@qq.com")
        (about: "Does awesome things")
        (@arg CONFIG: -c --config +takes_value "Sets a custom config file")
        (@arg INPUT: +required "Sets the input file to use")
        (@arg debug: -d ... "Sets the level of debugging information")
        (@subcommand test =>
            (about: "controls testing features")
            (version: "1.3")
            (author: "xiongxin@qq.com")
            (@arg verbose: -v --verbose "Print test information verbosely")
        )
    ).get_matches();

    if let Some(o) = matches.value_of("CONFIG") {
        println!("Value for output: {}", o);
    }

    if let Some(c) = matches.value_of("INPUT") {
        println!("Value for config: {}", c);
    }

    match matches.occurrences_of("debug") {
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
