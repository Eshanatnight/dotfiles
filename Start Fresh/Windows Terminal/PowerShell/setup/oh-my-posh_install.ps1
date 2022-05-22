# To check if the Path Exixts
function pathExists($path)
{
    if (Test-Path -Path $path)
    {
        return Write-Output "Path Exists";
    }

    else
    {
        Write-Output "Path Does Not Exist";
        mkdir $path;

        if(Test-Path -Path $path)
        {
            return $true;
        }

        Write-Error "Failed to create path";
        return $false;
    }
}

# To install the modules needed
function installModule()
{
    Write-Output "Module Installations";
    Write-Output "1. Terminal Icons";
    Write-Output "2. PSReadLine`n`n`n";
    Write-Output "Begining Installation .......`n`n";
    Install-Module -Name Terminal-Icons -Repository PSGallery;
    Install-Module PSReadLine -AllowPrerelease -Force;
}

# to test if the icons are working properly or not.
function testModule()
{
    Write-Output "Begining Test for the Terminal Icons Module"
    Import-Module -Name Terminal-Icons;
}

Write-Output "Installing OhMyPosh...."
winget install JanDeDobbeleer.OhMyPosh;

if($?)
{
    Write-Debug "Testing OhMyPosh installation.....";

    if(C:\Users\eshan\AppData\Local\Programs\oh-my-posh\bin\oh-my-posh.exe)
    {
        Write-Output "Test Passsed`n"
    }

    # Set path variables for the Powershell Folder and Theme Folder
    $testPathOne_ProfileFolder = "C:\Users\eshan\Documents\PowerShell"
    $testPathTwo_OMP_ThemeFolder = "D:\Tweaks\oh-my-posh";
    $testPathThree_PWSH_SettingsFolder = "C:\Users\eshan\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

    # Test if the path exists
    if(pathExists($testPathTwo_OMP_ThemeFolder))
    {
        Copy-Item -Path ".\Windows Terminal\PowerShell\Theme\oh-my-posh\ohmyposhv3-v2.json" -Destination $testPathTwo_OMP_ThemeFolder -Force;
    }

    Write-Output "Setting up the profile folder and its content....`n"
    pathExists($testPathOne_ProfileFolder);
    Copy-Item -Path '.\Windows Terminal\PowerShell\PowerShell_Profile\Microsoft.PowerShell_profile.ps1' -Destination "C:\Users\eshan\Documents\PowerShell" -Force;
    Write-Debug "Confirm The Profile File was Written Properly";
    code C:\Users\eshan\Documents\PowerShell\Microsoft.PowerShell_profile.ps1;

    Write-Output "Proceeding With Module Installations`n";
    installModule;

    testModule;


    # Note: Legacy
    <#
    Write-Output "Write Test Content to PowerShell Profile";
    Write-Output "C:\Users\eshan\AppData\Local\Programs\oh-my-posh\bin\oh-my-posh.exe --init --shell pwsh --config ~/jandedobbeleer.omp.json | Invoke-Expression" > C:\Users\eshan\Documents\PowerShell\Microsoft.PowerShell_profile.ps1;
    #>

    if(pathExists($testPathThree_PWSH_SettingsFolder))
    {
        Copy-Item -Path ".\Windows Terminal\settings.json" -Destination $testPathThree_PWSH_SettingsFolder -Force;
    }

    Write-Output "Installation Complete`nRestart Termina`n`n";
}



