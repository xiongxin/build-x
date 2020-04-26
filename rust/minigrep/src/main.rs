use std::env;
use std::fs;
use std::thread;
use std::time::Duration;


fn main() {
    // let args: Vec<String> = env::args().collect();
    // if args.len() < 3 {
    //     panic!("参数错误");
    // }

    // let config = parse_config(&args);
    // println!("Searching for {}", config.query);
    // println!("In file {}", config.filename);

    // let contents = fs::read_to_string(config.filename).expect("读取文件内存出错");


    let simulated_user_specified_value = 10;
    let simulated_random_number = 7;

    generate_workout(simulated_user_specified_value, simulated_random_number);

    let mut x = 4;

    let equal_to_x = |z| z == x;

    // x = 12;

    let y = 4;

    assert!(equal_to_x(y));
    x = 12;
}


struct Cacher<T>
where 
    T: Fn(u32) -> u32,
{
    calculation: T,
    value: Option<u32>,
}

impl<T> Cacher<T>
where
    T: Fn(u32) -> u32,
{
    fn new(calculation: T) -> Cacher<T> {
        Cacher {
            calculation,
            value: None
        }
    }

    fn value(&mut self, arg: u32) -> u32 {
        match self.value {
            Some(v) => v,
            None => {
                let v = (self.calculation)(arg);
                self.value = Some(v);
                v
            }
        }
    }
}

fn simulated_expensive_calculation(intensity: u32) -> u32 {
    println!("calculating slowly...");
    thread::sleep(Duration::from_secs(2));
    intensity
}

fn generate_workout(intensity: u32, random_number: u32) {

    let mut expensive_closure = Cacher::new(|num| {
        println!("calaculating slowly...");
        thread::sleep(Duration::from_secs(2));
        num
    });

    if intensity < 25 {
        println!("Today, do {} pushups", expensive_closure.value(intensity));
        println!("Next, do {} situps!", expensive_closure.value(intensity));
    } else {
        if random_number == 3 {
            println!("Take a break today! Remember to stay hydrated!");
        } else {
            println!("Today, run for {} minutes!", expensive_closure.value(intensity));
        }
    }

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
