$initial_path = Get-Location;

if(Test-Path -Path "D:\")
{
    if(!(Test-Path -Path "D:\tools\"))
    {
        mkdir 'D:\tools\'
    }

    Write-Output "Installing vcpkg in `D:\tools\vcpkg` ";

    Set-Location "D:\tools\";

    git clone https://github.com/microsoft/vcpkg.git;
    Set-Location .\vcpkg;
    .\bootstrap-vcpkg.bat;
}

Write-Host "add the path to the env variable `PATH` ";

Set-Location $initial_path;

