use std::fmt;
use std::io;
use rustc_serialize::json;

#[derive(Debug)]
pub enum MyError {
    Io(io::Error),
    Parse(json::DecoderError),
}
pub type MyResult<T> = Result<T, MyError>;

// Format implementation used when printing an error
impl fmt::Display for MyError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            MyError::Io(ref err) => err.fmt(f),
            MyError::Parse(ref err) => err.fmt(f),
        }
    }
}

// Absorb error types
impl From<io::Error> for MyError {
    fn from(err: io::Error) -> MyError { MyError::Io(err) }
}
impl From<json::DecoderError> for MyError {
    fn from(err: json::DecoderError) -> MyError { MyError::Parse(err) }
}
