extern crate rand;

pub fn add_one(x: i32) -> i32 {
    x + rand::random::<i32>()
}

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        assert_eq!(2 + 2, 4);
    }
}
