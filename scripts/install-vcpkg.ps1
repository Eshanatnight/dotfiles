$currentDir = Get-Location;

Write-Output "Changing Directory to .\vcpkg";
Set-Location D:\tools\vcpkg;

Start-Process git -ArgumentList "pull" -NoNewWindow -Wait

if($?)
{
    Write-Output "Pulling from Remote was Sucessful";
}
else
{
    Write-Output "Pulling from Remote repository failed";
    exit 1;
}

Write-Output "Bootstarpping vcpkg upgrade";
Start-Process -FilePath ".\bootstrap-vcpkg.bat" -NoNewWindow
Write-Output "Finished Bootstap";
Write-Output "Running Update";
Start-Process -FilePath ".\vcpkg.exe" -ArgumentList "update" -NoNewWindow;

if($?)
{
    Set-Location $currentDir;
    exit;
}
else
{
    Write-Error "Failed to reset directory.";
    exit;
}