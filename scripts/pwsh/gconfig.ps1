# add to safe dfirectory

$dir = Get-Location;

$i = 1;
Get-ChildItem -Path . -Directory -Recurse -Depth 1 |
    ForEach-Object -Process {
        Set-Location $_.FullName
        $current = Get-Location;
        Write-Output "$i. Configuring $current..."
        $i = $i + 1;
        Start-Process git -ArgumentList "config --global --add safe.directory `"$current`"" -NoNewWindow -Wait -RedirectStandardError $dir/err.txt -RedirectStandardOutput $dir/out.txt
}

Set-Location $dir;