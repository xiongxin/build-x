use std::error::Error;
use std::fmt;

#[derive(Debug)]
struct SuperError {
  side: SuperErrorSideKick,
}

impl fmt::Display for SuperError {
  fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
    write!(f, "SuperError is here")
  }
}

impl Error for SuperError {
  // fn source(&self) -> Option<&(dyn Error + 'static)> {
  //   Some(&self.side)
  // }
}

#[derive(Debug)]
struct SuperErrorSideKick;

impl fmt::Display for SuperErrorSideKick {
  fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
    write!(f, "SuperErrorSideKick is here!")
  }
}

impl Error for SuperErrorSideKick {}

fn get_super_error() -> Result<(), SuperError> {
  Err(SuperError { side: SuperErrorSideKick })
}

fn main() {
  match get_super_error() {
    Err(e) => {
      println!("Error: {}", e);
      println!("Caused by: {:?}", e.source());
    }
    _ => println!("No error"),
  }
}