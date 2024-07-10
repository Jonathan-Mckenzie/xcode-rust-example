uniffi::setup_scaffolding!();
 
#[uniffi::export]
fn rust_hello() -> String {
    "Hello from Rust! (update)".to_string()
}

#[uniffi::export]
pub fn rust_add(a: u32, b: u32) -> u32 {
    a + b
}
