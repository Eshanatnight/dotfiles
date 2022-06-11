# updates the rust toolchain
function update-rust-toolchain
{
    Write-Output "Updating Rust toolchain..."
    Start-Process rustup -ArgumentList "update" -NoNewWindow
}

# update the mingw toolchain
function update-mingw-toolchain
{
    Write-Output "Updating MinGW toolchain..."
    Start-Process mingw-get -ArgumentList "update" -NoNewWindow
    Start-Process mingw-get -ArgumentList "upgrade" -NoNewWindow
}

update-rust-toolchain
update-mingw-toolchain
