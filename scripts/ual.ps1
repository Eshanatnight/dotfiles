#pull down all changes of all repos from cloud

$dir = Get-Location;

Get-ChildItem -Path . -Directory -Recurse -Depth 0 |
    foreach {
        Set-Location $_.FullName
        Start-Process git -ArgumentList "pull" -Wait -NoNewWindow -WorkingDirectory $_.FullName
    };

Set-Location $dir;

exit(0);