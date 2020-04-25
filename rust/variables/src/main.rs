const MAX_POINTS: u32 = 100_000;
enum Message {
    Quit,
    Move {x: i32, y: i32},
    Write(String),
}
use Message::Write;
impl Message {
    fn call(&self) {
        match self {
            Message::Quit => println!("quite"),
            Message::Move{x, y} => println!("move, x ={}, y={}", x, y),
            Message::Write(s) => println!("s"),
        }
    }
}
fn main() {
    let mut x = 5;
    println!("The value of x is: {}", x);
    x = 6;
    println!("The value of x is: {}, {}", x, MAX_POINTS);

    let guess = "42".parse::<u32>().expect("Not a number");

    println!("The value of guess is: {}", guess);

    let tup = (500, 6.4, 1);

    println!("tup: {}", tup.0);
    
    
    let a = ["abc".to_owned(), "dd".to_owned()];

    for s in a.iter() {
        println!("the value is : {}", s);
    }

    println!("a[0]={}", a[0]);


    let s1 = String::from("hello");
    let s2 = s1.clone();

    println!("s1={}, s2={}", s1, s2);

    let mut s = String::from("hello ");

    let r1 = &s; // no problem
    let r2 = &s; // no problemhttp://localhost:8000/admin/login
    println!("{} and {}", r1, r2); // 已经使用过了，如果后面不再使用，就没毛病

    for (i, &item) in r1.as_bytes().iter().enumerate() {
        if item == b' ' {
            println!("item = {}", i);
        }
    }

    let mut s = String::from("Hello world");

    let word = first_word(&s);
    // println!("the first word is: {}", word);
    // s.clear();
    change_word(&mut s); // 我们这里修改了 word的引用数据，所以报错
                         // 这里使用了 &mut s 函数结束时，会释放掉这个可变引用

    // println!("the first word is: {}", &word);

    let message = Write("abc".to_owned());
    message.call();

    let c = Coin::Dime;
    println!("c = {}", value_in_cents(c));
    // println!("c = {}", value_in_cents(c));
}


enum Coin {
    Peeny,
    Nickel,
    Dime,
    Quarter,
}

fn value_in_cents(coin: Coin) -> u8 {
    match coin {
        Coin::Peeny => 1,
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter => 25
    }
}


fn change_word(s: &mut String) {
    s.pop();
}

fn first_word(s: &String) -> &str { // 返回值和s是同一生命周期，如果在同一生命周期内，同时有mut就会报错
    let bytes = s.as_bytes();

    for (i, &item) in bytes.iter().enumerate()  {
        if item == b' ' {
            return &s[0..i];
        }
    }

    return &s[..];
}


fn takes_ownership(some_string: String) {
    println!("{}", some_string);
}


