$current_path = Get-Location;

if(Test-Path -Path "D:\")
{
    if(!(Test-Path -Path "D:\Program Files\"))
    {
        mkdir 'D:\Program Files\'
    }

    Write-Output "Installing vcpkg in `D:\Program Files\vcpkg` ";

    Set-Location "D:\Program Files\";

    git clone https://github.com/microsoft/vcpkg.git;
    Set-Location .\vcpkg;
    .\bootstrap-vcpkg.bat;
}

Write-Host "add the path to the env variable `PATH` ";

Set-Location $current_path;

