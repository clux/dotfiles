#[macro_use]
extern crate clap;

extern crate mycrate;
use mycrate::*;

use clap::{Arg, App};

fn main() {
    let args = App::new("helloworld")
        .version(crate_version!())
        .about("hello word executable")
        .arg(Arg::with_name("world").short("w").takes_value(true))
        .get_matches();
    println!("Hello, {}!", args.value_of("world").unwrap_or("dude"));
}
