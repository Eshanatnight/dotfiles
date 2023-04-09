# calls clang-tidy

$dir = Get-Location;

Get-ChildItem -Path . -Directory -Recurse |
    foreach {
        Set-Location $_.FullName
        Start-Process clang-tidy -ArgumentList "*.cpp" -NoNewWindow -Wait
    };

Get-ChildItem -Path . -Directory -Recurse |
    foreach {
        Set-Location $_.FullName
        Start-Process clang-tidy -ArgumentList "*.h" -NoNewWindow -Wait
    };

Set-Location $dir;