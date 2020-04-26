use std::fs::File;
use std::error::Error;
use std::io::Write;


fn main() -> Result<(), Box<dyn Error>> {
    let mut f = File::open("hello.txt")?;
    f.flush();
    Ok(())
}
