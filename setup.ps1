# run winutils
# Invoke-RestMethod "https://christitus.com/win" | Invoke-Expression

function mklink {
    param(
        [Parameter(Mandatory = $true)]
        [string]$link,
        [Parameter(Mandatory = $true)]
        [string]$target
    )
    try {
        if (Test-Path -Path $link) {
            Write-Host "[INFO] Item already Exists $link, Bypassing Linking" -ForegroundColor Yellow
            return
        }
        New-Item -Path $link -ItemType SymbolicLink -Value $target -ErrorAction Stop
    } catch {
        Write-Host "[ERROR] Failed to create symbolic link $link -> $target`n" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
}

# Linking Config Files
[string]$PWD_PATH = $PWD.Path
[string]$GIT_CONFIG = "\.gitconfig"
mklink -link "$HOME$GIT_CONFIG".ToString() -target "$PWD_PATH$GIT_CONFIG".ToString()

[string]$GIT_IGNORE = "\.ignore"
mklink -link "$HOME$GIT_IGNORE".ToString() -target "$PWD_PATH$GIT_IGNORE".ToString()

[string]$CARGO_CONFIG = "\.cargo\config.toml"
mklink -link "$HOME$CARGO_CONFIG".ToString() -target "$PWD_PATH$CARGO_CONFIG".ToString()

[string]$STARSHIP_CONFIG = "\.config\starship.toml"
mklink -link "$HOME$STARSHIP_CONFIG".ToString() -target "$PWD_PATH$STARSHIP_CONFIG".ToString()

[string]$PROFILE_CONFIG = "\PowerShell\Microsoft.PowerShell_profile.ps1"
mklink -link "$HOME\OneDrive\Documents$PROFILE_CONFIG".ToString() -target "$PWD_PATH\Terminal$PROFILE_CONFIG".ToString()

[string]$OH_MY_POSH_CONFIG = "\oh-my-posh\ohmyposhv3-v2.json"
mklink -link "$HOME\Tweaks$OH_MY_POSH_CONFIG".ToString() -target "$PWD_PATH\Terminal\PowerShell\Theme$OH_MY_POSH_CONFIG".ToString()

[string]$WALLPAPERS = "\wallpapers"
mklink -link "$HOME\OneDrive$WALLPAPERS".ToString() -target "$PWD_PATH\wallpapers$WALLPAPERS".ToString()

[string]$SCRIPTS_DIR="$HOME\tools\scripts".ToString()
mkdir $SCRIPTS_DIR
Get-ChildItem -Path ($PWD_PATH + "\scripts\pwsh") -File | ForEach-Object {
    mklink -link ($SCRIPTS_DIR + "\" + $_.Name) -target $_.FullName
}


# Dependency Installation
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


if ($Error.Count -gt 0) {
    Write-Host "Errors Occurred During Installation" -ForegroundColor Magenta
    $response = Read-Host "Do You Want to View Errors? (Y/N)"
    if ($? -and $response -eq "Y") {
        Write-Host $Error -ForegroundColor DarkRed
    }
}