# run winutils
Invoke-RestMethod "https://christitus.com/win" | Invoke-Expression

function mklink {
    param(
        [Parameter(Mandatory = $true)]
        [string]$link,
        [Parameter(Mandatory = $true)]
        [string]$target
    )

    New-Item -Path $link -ItemType SymbolicLink -Value $target
}

# Linking Config Files
[string]$PWD_PATH = $PWD.Path
[string]$GIT_CONFIG = "\.gitconfig"
mklink("$HOME$GIT_CONFIG".ToString()) ("$PWD_PATH$GIT_CONFIG".ToString())

[string]$GIT_IGNORE = "\.ignore"
mklink("$HOME$GIT_IGNORE".ToString()) ("$PWD_PATH$GIT_IGNORE".ToString())

[string]$CARGO_CONFIG = "\.cargo\config.toml"
mklink ("$HOME$CARGO_CONFIG".ToString()) ("$PWD_PATH$CARGO_CONFIG".ToString())

[string]$STARSHIP_CONFIG = "\.config\starship.toml"
mklink("$HOME$STARSHIP_CONFIG".ToString()) ("$PWD_PATH$STARSHIP_CONFIG".ToString())

[string]$PROFILE_CONFIG = "\PowerShell\Microsoft.PowerShell_profile.ps1"
mklink ("$HOME\OneDrive\Documents$PROFILE_CONFIG".ToString()) ("$PWD_PATH\Terminal$PROFILE_CONFIG".ToString())

[string]$OH_MY_POSH_CONFIG = "\oh-my-posh\ohmyposhv3-v2.json"
mklink ("$HOME\Tweaks$OH_MY_POSH_CONFIG".ToString()) ("$PWD_PATH\Terminal\PowerShell\Theme$OH_MY_POSH_CONFIG".ToString())

[string]$WALLPAPERS = "\wallpapers"
mklink ("$HOME\OneDrive\$WALLPAPERS".ToString()) ("$PWD_PATH\wallpapers$WALLPAPERS".ToString())

mkdir $HOME + "\tools\scripts"
Get-ChildItem -Path ($PWD_PATH + "\scripts\pwsh") -File | ForEach-Object {
    mklink ($HOME + "\tools\scripts\" + $_.Name) $_.FullName
}


Dependency Installation
[string[]]$PACKAGES = @("BurntSushi.ripgrep.MSVC", "Bitwarden.Bitwarden", "ModernFlyouts.ModernFlyouts", "Microsoft.PowerToys", "JFrog.Conan", "Docker.DockerDesktop", "Git.Git", "Google.Chrome", "JesseDuffield.lazygit", "Ninja-build.Ninja", "JanDeDobbeleer.OhMyPosh", "Rainmeter.Rainmeter", "SumatraPDF.SumatraPDF", "VideoLAN.VLC", "ajeetdsouza.zoxide", "OliverSchwendener.ueli", "equalsraf.win32yank", "junegunn.fzf", "sharkdp.bat", "tldr-pages.tlrc", "Giorgiotani.Peazip", "Microsoft.PowerShell", "RevoUninstaller.RevoUninstaller", "Nilesoft.Shell", "GitHub.cli", "Kitware.CMake", "Microsoft.VisualStudioCode")

foreach ($package in $PACKAGES) {
    winget install --id $package
}

Write-Output "Install Rustup and MSYS2 Manually"

[string[]]$OPTIONAL_PACKAGES = @("FiloSottile.mkcert", "Postman.Postman", "AntibodySoftware.WizTree", "MiniTool.PartitionWizard.Free")
$INSTALL_OPTIONAL_PACKAGES = Read-Host "Do You Want to Install Optional Packages? (Y/N)"

if ($INSTALL_OPTIONAL_PACKAGES -eq "Y") {
    foreach ($package in $OPTIONAL_PACKAGES) {
        winget install --id $package
    }
}

if (!(Test-Path $HOME + "\tools\vcpkg")) {
    Write-Output "Installing VCPkg"
    git clone "https://github.com/microsoft/vcpkg.git" ($HOME + "\tools\vcpkg")
}