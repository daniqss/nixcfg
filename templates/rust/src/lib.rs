pub mod error;
pub mod prelude;
pub mod utils;

use crate::prelude::*;

pub fn run() -> Result<()> {
    println!("{:#?}", utils::CRATE_NAME);

    Ok(())
}
