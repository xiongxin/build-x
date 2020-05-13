use clap::{App, load_yaml};
use std::env;



fn main() {

    let args: Vec<String> = env::args().collect();

    println!("{:?}", args);


    let yaml = load_yaml!("cli.yml");
    let m = App::from(yaml).get_matches();

    // match m.value_of("argument1") {

    // }
}
