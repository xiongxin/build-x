mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

pub fn eat_at_restaurant() {
    // Absolute path
    crate::front_of_house::hosting::add_to_waitlist();

    // Relative path
    front_of_house::hosting::add_to_waitlist();
}

fn serve_order() {}

mod back_of_house {
    fn fix_incorrenct_order() {
        cook_order();
        super::serve_order();
    }

    fn cook_order() {}
}

use std::fmt::Result;
use std::io::Result as IOResult;

fn fn1() -> Result {
    Ok(())
}

fn fn2() -> IOResult<()> {
    Ok(())
}