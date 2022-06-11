# updates the rust toolchain
function update-rust-toolchain
{
    Write-Output "Updating Rust toolchain..."
    Start-Process rustup -ArgumentList "update" -NoNewWindow
}

update-rust-toolchain
