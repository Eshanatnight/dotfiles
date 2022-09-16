$dir = Get-Location;

Get-ChildItem -Path . -Directory -Recurse |
    foreach {
        Set-Location $_.FullName
        Start-Process clang-format -ArgumentList "-i *.cpp" -NoNewWindow -Wait
    };

Get-ChildItem -Path . -Directory -Recurse |
    foreach {
        Set-Location $_.FullName
        Start-Process clang-format -ArgumentList "-i *.h" -NoNewWindow -Wait
    };

Set-Location $dir;