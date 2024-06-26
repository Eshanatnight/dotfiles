if ($host.Name -eq 'ConsoleHost') {
    if (Get-Module -ListAvailable -Name PSReadLine) {
        Import-Module PSReadLine
    } else {
        Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck
        Import-Module PSReadLine
    }
}

# chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

# Invoke Terminal Icons
if (Get-Module -ListAvailable -Name Terminal-Icons) {
    Import-Module -Name Terminal-Icons
} else {
    Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -SkipPublisherCheck
    Import-Module -Name Terminal-Icons

}
# git suggestions
if (Get-Module -ListAvailable -Name posh-git) {
    Import-Module -Name posh-git
} else {
    Install-Module -Name posh-git -Scope CurrentUser -Force -SkipPublisherCheck
    Import-Module -Name posh-git
}

# vcpkg
$VCPKG_PROFILE = "C:\Users\acer\tools\vcpkg\scripts\posh-vcpkg"
if (Test-Path($VCPKG_PROFILE)) {
    Import-Module "$VCPKG_PROFILE"
} else {
    Write-Output "vcpkg is not installed"
    Start-Process -FilePath "git" -ArgumentList "clone", "https://github.com/microsoft/vcpkg.git", "$HOME\tools\vcpkg" -NoNewWindow
    Import-Module "$VCPKG_PROFILE"
}

<#
# Invoke Oh My Posh
# I am not using oh-my-posh anymore, I have switched to starship

C:\Users\acer\AppData\Local\Programs\oh-my-posh\bin\oh-my-posh.exe --init `
    --shell pwsh `
    --config C:\Users\acer\Tweaks\oh-my-posh\ohmyposhv3-v2.json | Invoke-Expression
#>

Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })

Set-PSReadLineOption -Colors @{
    Command            = [ConsoleColor]::Magenta
    Parameter          = [ConsoleColor]::Green
    String             = [ConsoleColor]::Cyan
    Number             = [ConsoleColor]::Green
    Error              = [ConsoleColor]::DarkRed
    ContinuationPrompt = [ConsoleColor]::Blue
    Member             = [ConsoleColor]::White
    Operator           = [ConsoleColor]::DarkGreen
    Type               = [ConsoleColor]::DarkGray
    Variable           = [ConsoleColor]::DarkGreen
}

Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# Insert text from the clipboard as a here string
Set-PSReadLineKeyHandler -Key Ctrl+V `
    -BriefDescription PasteAsHereString `
    -LongDescription "Paste the clipboard text as a here string" `
    -ScriptBlock {
    param($key, $arg)

    Add-Type -Assembly PresentationCore
    if ([System.Windows.Clipboard]::ContainsText()) {
        # Get clipboard text - remove trailing spaces, convert \r\n to \n, and remove the final \n.
        $text = ([System.Windows.Clipboard]::GetText() -replace "\p{Zs}*`r?`n", "`n").TrimEnd()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("@'`n$text`n'@")
    }
    else {
        [Microsoft.PowerShell.PSConsoleReadLine]::Ding()
    }
}

# Insert text from the clipboard as a here string
Set-PSReadLineKeyHandler -Key Ctrl+V `
    -BriefDescription PasteAsHereString `
    -LongDescription "Paste the clipboard text as a here string" `
    -ScriptBlock {
    param($key, $arg)

    Add-Type -Assembly PresentationCore
    if ([System.Windows.Clipboard]::ContainsText()) {
        # Get clipboard text - remove trailing spaces, convert \r\n to \n, and remove the final \n.
        $text = ([System.Windows.Clipboard]::GetText() -replace "\p{Zs}*`r?`n", "`n").TrimEnd()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("@'`n$text`n'@")
    }
    else {
        [Microsoft.PowerShell.PSConsoleReadLine]::Ding()
    }
}

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

function Get-Env {
    param(
        [Parameter(Mandatory = $true)]
        [String] $Key
    )

    $RegisterKey = Get-Item -Path 'HKCU:'
    $EnvRegisterKey = $RegisterKey.OpenSubKey('Environment')
    $EnvRegisterKey.GetValue($Key, $null, [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames)
}

# These three environment functions are roughly copied from https://github.com/prefix-dev/pixi/pull/692
# They are used instead of `SetEnvironmentVariable` because of unwanted variable expansions.
function Publish-Env {
    if (-not ("Win32.NativeMethods" -as [Type])) {
        <# dllimport should not be needed but still#>
        Add-Type -Namespace Win32 -Name NativeMethods -MemberDefinition @"
[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
public static extern IntPtr SendMessageTimeout(
    IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam,
    uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
"@
    }
    $HWND_BROADCAST = [IntPtr] 0xffff
    $WM_SETTINGCHANGE = 0x1a
    $result = [UIntPtr]::Zero
    [Win32.NativeMethods]::SendMessageTimeout($HWND_BROADCAST,
        $WM_SETTINGCHANGE,
        [UIntPtr]::Zero,
        "Environment",
        2,
        5000,
        [ref] $result
    ) | Out-Null
}

function Write-Env {
    param(
        [Parameter(Mandatory = $true)]
        [String]$Key,
        [String]$Value
    )

    [Microsoft.Win32.RegistryKey]$RegisterKey = Get-Item -Path 'HKCU:'


    [Microsoft.Win32.RegistryKey]$EnvRegisterKey = $RegisterKey.OpenSubKey('Environment', $true)
    if ($null -eq $Value) {
        $EnvRegisterKey.DeleteValue($Key)
    }
    else {
        $RegistryValueKind = if ($Value.Contains('%')) {
            [Microsoft.Win32.RegistryValueKind]::ExpandString
        }
        elseif ($EnvRegisterKey.GetValue($Key)) {
            $EnvRegisterKey.GetValueKind($Key)
        }
        else {
            [Microsoft.Win32.RegistryValueKind]::String
        }
        $EnvRegisterKey.SetValue($Key, $Value, $RegistryValueKind)
    }

    Publish-Env
}


function Update-Path {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$NEW_PATH
    )
   $PATH = (Get-Env -Key "Path") -split ';'
    if ($Path -notcontains $NEW_PATH) {
        $Path += $NEW_PATH
        Write-Env -Key 'Path' -Value ($Path -join ';')
        $env:PATH = $Path;
    }

}

# Source the profile
function s {
    & ${PROFILE}
    . ${PROFILE}
}

# reload $PATH for current env
function rfenv {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

# take will create a new directory and change into it
function take {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$directory
    )

    New-Item -ItemType Directory -Force -Path $directory | Out-Null;
    Set-Location $directory;
}

# Update all installed packages
function update {
    sudo winget upgrade --all --include-unknown;
    sudo choco upgrade all -y
}

# export env variable
function export {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$name,
        [Parameter(Mandatory = $true)]
        [string]$value)
    set-item -force -path "env:$name" -value $value;
}

# quick repair
function repair {
    DISM.exe /Online /Cleanup-image /Restorehealth;
    if ($?) {
        # sfc to can and download the corrected image
        sfc /scannow
    };
}

# use bat for better git diff
function bd {
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
}

# git pull
function pull {
    git pull
}

# git fetch
function f {
    git fetch --prune
}

# git log with graph
function lg {
    git lg
}

#  git checkout with fzf
function gco() {
    param(
        [string]$branch
    )
    Write-Output "running gco func"
    if ( $branch) {
        # pass the args to git checkout
        git checkout $branch
        $?
    }
    else {
        # search for a branch w/ fuzzy finder and then check it out
        git branch | fzf --reverse --header='Checkout a git branch' --header-first --cycle | xargs git checkout
    }
}

# git branch delete with fzf
function gd {
    $branch=$(git branch | fzf --reverse --header='Checkout a git branch' --header-first --cycle | sed 's/^\* //;s/^  //')
    if (-not $?) {
        return
    }

    $header="Are You Sure You want to Delete $branch"
    $response=$(Write-Output "Yes`nNo" | fzf --reverse --header="$header" --header-first --cycle)
    if (-not $?) {
        return
    }
    if($response -eq "Yes") {
        git branch -D $branch;
    }
}


# git switch with fzf
function gs {
    param(
        [string]$branch
    )
    Write-Output "running gs func"
    if ($branch) {
        git switch $branch
    }
    else {
        git branch -a | grep 'remotes/origin/' | sed 's#remotes/origin/##' | fzf --reverse --header='Switch to a remote git branch' --header-first --cycle | xargs git switch
    }
}

# get a file from a different branch
function get {
    [CmdletBinding()]
    param(
        [string]$branch,
        [string]$path
    )
    git checkout $branch -- $path
}

# unzip a file
function unzip {
    [CmdletBinding()]
    param(
        [string]$file
    )
    Write-Output("Extracting", $file, "to", $pwd)
    $fullFile = Get-ChildItem -Path $pwd -Filter $file | ForEach-Object { $_.FullName }
    Expand-Archive -Path $fullFile -DestinationPath $pwd
}

# util function to make symlinks
function mklink {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$link,
        [Parameter(Mandatory = $true)]
        [string]$target
    )

    New-Item -Path $link -ItemType SymbolicLink -Value $target
}

function rmrf {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$path
    )
    Remove-Item -r -Force $path
}

Set-Alias -Name make -Value mingw32-make
Set-Alias -Name la -Value ls
Set-Alias -Name df -Value Get-Volume
Set-Alias -Name wh -Value where.exe

# env vars
$Env:CMAKE_TOOLCHAIN_FILE = "$HOME/tools/vcpkg/scripts/buildsystems/vcpkg.cmake"
$Env:CMAKE_EXPORT_COMPILE_COMMANDS = 1
$Env:FZF_DEFAULT_OPTS = "--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
$Env:STARSHIP_CONFIG= "$HOME/.config/starship.toml"

# argument completions
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
    $Local:word = $wordToComplete.Replace('"', '""')
    $Local:ast = $commandAst.ToString().Replace('"', '""')
    winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

Register-ArgumentCompleter -Native -CommandName 'rustup' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $commandElements = $commandAst.CommandElements
    $command = @(
        'rustup'
        for ($i = 1; $i -lt $commandElements.Count; $i++) {
            $element = $commandElements[$i]
            if ($element -isnot [StringConstantExpressionAst] -or
                $element.StringConstantType -ne [StringConstantType]::BareWord -or
                $element.Value.StartsWith('-') -or
                $element.Value -eq $wordToComplete) {
                break
            }
            $element.Value
        }) -join ';'

    $completions = @(switch ($command) {
            'rustup' {
                [CompletionResult]::new('-v', 'v', [CompletionResultType]::ParameterName, 'Enable verbose output')
                [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enable verbose output')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Disable progress output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Disable progress output')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('-V', 'V ', [CompletionResultType]::ParameterName, 'Print version')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Print version')
                [CompletionResult]::new('dump-testament', 'dump-testament', [CompletionResultType]::ParameterValue, 'Dump information about the build')
                [CompletionResult]::new('show', 'show', [CompletionResultType]::ParameterValue, 'Show the active and installed toolchains or profiles')
                [CompletionResult]::new('install', 'install', [CompletionResultType]::ParameterValue, 'Update Rust toolchains')
                [CompletionResult]::new('uninstall', 'uninstall', [CompletionResultType]::ParameterValue, 'Uninstall Rust toolchains')
                [CompletionResult]::new('update', 'update', [CompletionResultType]::ParameterValue, 'Update Rust toolchains and rustup')
                [CompletionResult]::new('check', 'check', [CompletionResultType]::ParameterValue, 'Check for updates to Rust toolchains and rustup')
                [CompletionResult]::new('default', 'default', [CompletionResultType]::ParameterValue, 'Set the default toolchain')
                [CompletionResult]::new('toolchain', 'toolchain', [CompletionResultType]::ParameterValue, 'Modify or query the installed toolchains')
                [CompletionResult]::new('target', 'target', [CompletionResultType]::ParameterValue, 'Modify a toolchain''s supported targets')
                [CompletionResult]::new('component', 'component', [CompletionResultType]::ParameterValue, 'Modify a toolchain''s installed components')
                [CompletionResult]::new('override', 'override', [CompletionResultType]::ParameterValue, 'Modify toolchain overrides for directories')
                [CompletionResult]::new('run', 'run', [CompletionResultType]::ParameterValue, 'Run a command with an environment configured for a given toolchain')
                [CompletionResult]::new('which', 'which', [CompletionResultType]::ParameterValue, 'Display which binary will be run for a given command')
                [CompletionResult]::new('doc', 'doc', [CompletionResultType]::ParameterValue, 'Open the documentation for the current toolchain')
                [CompletionResult]::new('self', 'self', [CompletionResultType]::ParameterValue, 'Modify the rustup installation')
                [CompletionResult]::new('set', 'set', [CompletionResultType]::ParameterValue, 'Alter rustup settings')
                [CompletionResult]::new('completions', 'completions', [CompletionResultType]::ParameterValue, 'Generate tab-completion scripts for your shell')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
                break
            }
            'rustup;dump-testament' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;show' {
                [CompletionResult]::new('-v', 'v', [CompletionResultType]::ParameterName, 'Enable verbose output with rustc information for all installed toolchains')
                [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enable verbose output with rustc information for all installed toolchains')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('active-toolchain', 'active-toolchain', [CompletionResultType]::ParameterValue, 'Show the active toolchain')
                [CompletionResult]::new('home', 'home', [CompletionResultType]::ParameterValue, 'Display the computed value of RUSTUP_HOME')
                [CompletionResult]::new('profile', 'profile', [CompletionResultType]::ParameterValue, 'Show the default profile used for the `rustup install` command')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
                break
            }
            'rustup;show;active-toolchain' {
                [CompletionResult]::new('-v', 'v', [CompletionResultType]::ParameterName, 'Enable verbose output with rustc information')
                [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enable verbose output with rustc information')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;show;home' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;show;profile' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;show;help' {
                [CompletionResult]::new('active-toolchain', 'active-toolchain', [CompletionResultType]::ParameterValue, 'Show the active toolchain')
                [CompletionResult]::new('home', 'home', [CompletionResultType]::ParameterValue, 'Display the computed value of RUSTUP_HOME')
                [CompletionResult]::new('profile', 'profile', [CompletionResultType]::ParameterValue, 'Show the default profile used for the `rustup install` command')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
                break
            }
            'rustup;show;help;active-toolchain' {
                break
            }
            'rustup;show;help;home' {
                break
            }
            'rustup;show;help;profile' {
                break
            }
            'rustup;show;help;help' {
                break
            }
            'rustup;install' {
                [CompletionResult]::new('--profile', 'profile', [CompletionResultType]::ParameterName, 'profile')
                [CompletionResult]::new('--no-self-update', 'no-self-update', [CompletionResultType]::ParameterName, 'Don''t perform self-update when running the `rustup install` command')
                [CompletionResult]::new('--force', 'force', [CompletionResultType]::ParameterName, 'Force an update, even if some components are missing')
                [CompletionResult]::new('--force-non-host', 'force-non-host', [CompletionResultType]::ParameterName, 'Install toolchains that require an emulator. See https://github.com/rust-lang/rustup/wiki/Non-host-toolchains')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;uninstall' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;update' {
                [CompletionResult]::new('--no-self-update', 'no-self-update', [CompletionResultType]::ParameterName, 'Don''t perform self update when running the `rustup update` command')
                [CompletionResult]::new('--force', 'force', [CompletionResultType]::ParameterName, 'Force an update, even if some components are missing')
                [CompletionResult]::new('--force-non-host', 'force-non-host', [CompletionResultType]::ParameterName, 'Install toolchains that require an emulator. See https://github.com/rust-lang/rustup/wiki/Non-host-toolchains')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;check' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;default' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;toolchain' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List installed toolchains')
                [CompletionResult]::new('install', 'install', [CompletionResultType]::ParameterValue, 'Install or update a given toolchain')
                [CompletionResult]::new('uninstall', 'uninstall', [CompletionResultType]::ParameterValue, 'Uninstall a toolchain')
                [CompletionResult]::new('link', 'link', [CompletionResultType]::ParameterValue, 'Create a custom toolchain by symlinking to a directory')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
                break
            }
            'rustup;toolchain;list' {
                [CompletionResult]::new('-v', 'v', [CompletionResultType]::ParameterName, 'Enable verbose output with toolchain information')
                [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enable verbose output with toolchain information')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;toolchain;install' {
                [CompletionResult]::new('--profile', 'profile', [CompletionResultType]::ParameterName, 'profile')
                [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Add specific components on installation')
                [CompletionResult]::new('--component', 'component', [CompletionResultType]::ParameterName, 'Add specific components on installation')
                [CompletionResult]::new('-t', 't', [CompletionResultType]::ParameterName, 'Add specific targets on installation')
                [CompletionResult]::new('--target', 'target', [CompletionResultType]::ParameterName, 'Add specific targets on installation')
                [CompletionResult]::new('--no-self-update', 'no-self-update', [CompletionResultType]::ParameterName, 'Don''t perform self update when running the`rustup toolchain install` command')
                [CompletionResult]::new('--force', 'force', [CompletionResultType]::ParameterName, 'Force an update, even if some components are missing')
                [CompletionResult]::new('--allow-downgrade', 'allow-downgrade', [CompletionResultType]::ParameterName, 'Allow rustup to downgrade the toolchain to satisfy your component choice')
                [CompletionResult]::new('--force-non-host', 'force-non-host', [CompletionResultType]::ParameterName, 'Install toolchains that require an emulator. See https://github.com/rust-lang/rustup/wiki/Non-host-toolchains')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;toolchain;uninstall' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;toolchain;link' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;toolchain;help' {
                [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List installed toolchains')
                [CompletionResult]::new('install', 'install', [CompletionResultType]::ParameterValue, 'Install or update a given toolchain')
                [CompletionResult]::new('uninstall', 'uninstall', [CompletionResultType]::ParameterValue, 'Uninstall a toolchain')
                [CompletionResult]::new('link', 'link', [CompletionResultType]::ParameterValue, 'Create a custom toolchain by symlinking to a directory')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
                break
            }
            'rustup;toolchain;help;list' {
                break
            }
            'rustup;toolchain;help;install' {
                break
            }
            'rustup;toolchain;help;uninstall' {
                break
            }
            'rustup;toolchain;help;link' {
                break
            }
            'rustup;toolchain;help;help' {
                break
            }
            'rustup;target' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List installed and available targets')
                [CompletionResult]::new('add', 'add', [CompletionResultType]::ParameterValue, 'Add a target to a Rust toolchain')
                [CompletionResult]::new('remove', 'remove', [CompletionResultType]::ParameterValue, 'Remove a target from a Rust toolchain')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
                break
            }
            'rustup;target;list' {
                [CompletionResult]::new('--toolchain', 'toolchain', [CompletionResultType]::ParameterName, 'Toolchain name, such as ''stable'', ''nightly'', or ''1.8.0''. For more information see `rustup help toolchain`')
                [CompletionResult]::new('--installed', 'installed', [CompletionResultType]::ParameterName, 'List only installed targets')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;target;add' {
                [CompletionResult]::new('--toolchain', 'toolchain', [CompletionResultType]::ParameterName, 'Toolchain name, such as ''stable'', ''nightly'', or ''1.8.0''. For more information see `rustup help toolchain`')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;target;remove' {
                [CompletionResult]::new('--toolchain', 'toolchain', [CompletionResultType]::ParameterName, 'Toolchain name, such as ''stable'', ''nightly'', or ''1.8.0''. For more information see `rustup help toolchain`')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;target;help' {
                [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List installed and available targets')
                [CompletionResult]::new('add', 'add', [CompletionResultType]::ParameterValue, 'Add a target to a Rust toolchain')
                [CompletionResult]::new('remove', 'remove', [CompletionResultType]::ParameterValue, 'Remove a target from a Rust toolchain')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
                break
            }
            'rustup;target;help;list' {
                break
            }
            'rustup;target;help;add' {
                break
            }
            'rustup;target;help;remove' {
                break
            }
            'rustup;target;help;help' {
                break
            }
            'rustup;component' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List installed and available components')
                [CompletionResult]::new('add', 'add', [CompletionResultType]::ParameterValue, 'Add a component to a Rust toolchain')
                [CompletionResult]::new('remove', 'remove', [CompletionResultType]::ParameterValue, 'Remove a component from a Rust toolchain')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
                break
            }
            'rustup;component;list' {
                [CompletionResult]::new('--toolchain', 'toolchain', [CompletionResultType]::ParameterName, 'Toolchain name, such as ''stable'', ''nightly'', or ''1.8.0''. For more information see `rustup help toolchain`')
                [CompletionResult]::new('--installed', 'installed', [CompletionResultType]::ParameterName, 'List only installed components')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;component;add' {
                [CompletionResult]::new('--toolchain', 'toolchain', [CompletionResultType]::ParameterName, 'Toolchain name, such as ''stable'', ''nightly'', or ''1.8.0''. For more information see `rustup help toolchain`')
                [CompletionResult]::new('--target', 'target', [CompletionResultType]::ParameterName, 'target')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;component;remove' {
                [CompletionResult]::new('--toolchain', 'toolchain', [CompletionResultType]::ParameterName, 'Toolchain name, such as ''stable'', ''nightly'', or ''1.8.0''. For more information see `rustup help toolchain`')
                [CompletionResult]::new('--target', 'target', [CompletionResultType]::ParameterName, 'target')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;component;help' {
                [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List installed and available components')
                [CompletionResult]::new('add', 'add', [CompletionResultType]::ParameterValue, 'Add a component to a Rust toolchain')
                [CompletionResult]::new('remove', 'remove', [CompletionResultType]::ParameterValue, 'Remove a component from a Rust toolchain')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
                break
            }
            'rustup;component;help;list' {
                break
            }
            'rustup;component;help;add' {
                break
            }
            'rustup;component;help;remove' {
                break
            }
            'rustup;component;help;help' {
                break
            }
            'rustup;override' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List directory toolchain overrides')
                [CompletionResult]::new('set', 'set', [CompletionResultType]::ParameterValue, 'Set the override toolchain for a directory')
                [CompletionResult]::new('unset', 'unset', [CompletionResultType]::ParameterValue, 'Remove the override toolchain for a directory')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
                break
            }
            'rustup;override;list' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;override;set' {
                [CompletionResult]::new('--path', 'path', [CompletionResultType]::ParameterName, 'Path to the directory')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;override;unset' {
                [CompletionResult]::new('--path', 'path', [CompletionResultType]::ParameterName, 'Path to the directory')
                [CompletionResult]::new('--nonexistent', 'nonexistent', [CompletionResultType]::ParameterName, 'Remove override toolchain for all nonexistent directories')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;override;help' {
                [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List directory toolchain overrides')
                [CompletionResult]::new('set', 'set', [CompletionResultType]::ParameterValue, 'Set the override toolchain for a directory')
                [CompletionResult]::new('unset', 'unset', [CompletionResultType]::ParameterValue, 'Remove the override toolchain for a directory')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
                break
            }
            'rustup;override;help;list' {
                break
            }
            'rustup;override;help;set' {
                break
            }
            'rustup;override;help;unset' {
                break
            }
            'rustup;override;help;help' {
                break
            }
            'rustup;run' {
                [CompletionResult]::new('--install', 'install', [CompletionResultType]::ParameterName, 'Install the requested toolchain if needed')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;which' {
                [CompletionResult]::new('--toolchain', 'toolchain', [CompletionResultType]::ParameterName, 'Toolchain name, such as ''stable'', ''nightly'', ''1.8.0'', or a custom toolchain name. For more information see `rustup help toolchain`')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;doc' {
                [CompletionResult]::new('--toolchain', 'toolchain', [CompletionResultType]::ParameterName, 'Toolchain name, such as ''stable'', ''nightly'', or ''1.8.0''. For more information see `rustup help toolchain`')
                [CompletionResult]::new('--path', 'path', [CompletionResultType]::ParameterName, 'Only print the path to the documentation')
                [CompletionResult]::new('--alloc', 'alloc', [CompletionResultType]::ParameterName, 'The Rust core allocation and collections library')
                [CompletionResult]::new('--book', 'book', [CompletionResultType]::ParameterName, 'The Rust Programming Language book')
                [CompletionResult]::new('--cargo', 'cargo', [CompletionResultType]::ParameterName, 'The Cargo Book')
                [CompletionResult]::new('--core', 'core', [CompletionResultType]::ParameterName, 'The Rust Core Library')
                [CompletionResult]::new('--edition-guide', 'edition-guide', [CompletionResultType]::ParameterName, 'The Rust Edition Guide')
                [CompletionResult]::new('--nomicon', 'nomicon', [CompletionResultType]::ParameterName, 'The Dark Arts of Advanced and Unsafe Rust Programming')
                [CompletionResult]::new('--proc_macro', 'proc_macro', [CompletionResultType]::ParameterName, 'A support library for macro authors when defining new macros')
                [CompletionResult]::new('--reference', 'reference', [CompletionResultType]::ParameterName, 'The Rust Reference')
                [CompletionResult]::new('--rust-by-example', 'rust-by-example', [CompletionResultType]::ParameterName, 'A collection of runnable examples that illustrate various Rust concepts and standard libraries')
                [CompletionResult]::new('--rustc', 'rustc', [CompletionResultType]::ParameterName, 'The compiler for the Rust programming language')
                [CompletionResult]::new('--rustdoc', 'rustdoc', [CompletionResultType]::ParameterName, 'Documentation generator for Rust projects')
                [CompletionResult]::new('--std', 'std', [CompletionResultType]::ParameterName, 'Standard library API documentation')
                [CompletionResult]::new('--test', 'test', [CompletionResultType]::ParameterName, 'Support code for rustc''s built in unit-test and micro-benchmarking framework')
                [CompletionResult]::new('--unstable-book', 'unstable-book', [CompletionResultType]::ParameterName, 'The Unstable Book')
                [CompletionResult]::new('--embedded-book', 'embedded-book', [CompletionResultType]::ParameterName, 'The Embedded Rust Book')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;self' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('update', 'update', [CompletionResultType]::ParameterValue, 'Download and install updates to rustup')
                [CompletionResult]::new('uninstall', 'uninstall', [CompletionResultType]::ParameterValue, 'Uninstall rustup.')
                [CompletionResult]::new('upgrade-data', 'upgrade-data', [CompletionResultType]::ParameterValue, 'Upgrade the internal data format.')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
                break
            }
            'rustup;self;update' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;self;uninstall' {
                [CompletionResult]::new('-y', 'y', [CompletionResultType]::ParameterName, 'y')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;self;upgrade-data' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;self;help' {
                [CompletionResult]::new('update', 'update', [CompletionResultType]::ParameterValue, 'Download and install updates to rustup')
                [CompletionResult]::new('uninstall', 'uninstall', [CompletionResultType]::ParameterValue, 'Uninstall rustup.')
                [CompletionResult]::new('upgrade-data', 'upgrade-data', [CompletionResultType]::ParameterValue, 'Upgrade the internal data format.')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
                break
            }
            'rustup;self;help;update' {
                break
            }
            'rustup;self;help;uninstall' {
                break
            }
            'rustup;self;help;upgrade-data' {
                break
            }
            'rustup;self;help;help' {
                break
            }
            'rustup;set' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('default-host', 'default-host', [CompletionResultType]::ParameterValue, 'The triple used to identify toolchains when not specified')
                [CompletionResult]::new('profile', 'profile', [CompletionResultType]::ParameterValue, 'The default components installed with a toolchain')
                [CompletionResult]::new('auto-self-update', 'auto-self-update', [CompletionResultType]::ParameterValue, 'The rustup auto self update mode')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
                break
            }
            'rustup;set;default-host' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;set;profile' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;set;auto-self-update' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;set;help' {
                [CompletionResult]::new('default-host', 'default-host', [CompletionResultType]::ParameterValue, 'The triple used to identify toolchains when not specified')
                [CompletionResult]::new('profile', 'profile', [CompletionResultType]::ParameterValue, 'The default components installed with a toolchain')
                [CompletionResult]::new('auto-self-update', 'auto-self-update', [CompletionResultType]::ParameterValue, 'The rustup auto self update mode')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
                break
            }
            'rustup;set;help;default-host' {
                break
            }
            'rustup;set;help;profile' {
                break
            }
            'rustup;set;help;auto-self-update' {
                break
            }
            'rustup;set;help;help' {
                break
            }
            'rustup;completions' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
                break
            }
            'rustup;help' {
                [CompletionResult]::new('dump-testament', 'dump-testament', [CompletionResultType]::ParameterValue, 'Dump information about the build')
                [CompletionResult]::new('show', 'show', [CompletionResultType]::ParameterValue, 'Show the active and installed toolchains or profiles')
                [CompletionResult]::new('install', 'install', [CompletionResultType]::ParameterValue, 'Update Rust toolchains')
                [CompletionResult]::new('uninstall', 'uninstall', [CompletionResultType]::ParameterValue, 'Uninstall Rust toolchains')
                [CompletionResult]::new('update', 'update', [CompletionResultType]::ParameterValue, 'Update Rust toolchains and rustup')
                [CompletionResult]::new('check', 'check', [CompletionResultType]::ParameterValue, 'Check for updates to Rust toolchains and rustup')
                [CompletionResult]::new('default', 'default', [CompletionResultType]::ParameterValue, 'Set the default toolchain')
                [CompletionResult]::new('toolchain', 'toolchain', [CompletionResultType]::ParameterValue, 'Modify or query the installed toolchains')
                [CompletionResult]::new('target', 'target', [CompletionResultType]::ParameterValue, 'Modify a toolchain''s supported targets')
                [CompletionResult]::new('component', 'component', [CompletionResultType]::ParameterValue, 'Modify a toolchain''s installed components')
                [CompletionResult]::new('override', 'override', [CompletionResultType]::ParameterValue, 'Modify toolchain overrides for directories')
                [CompletionResult]::new('run', 'run', [CompletionResultType]::ParameterValue, 'Run a command with an environment configured for a given toolchain')
                [CompletionResult]::new('which', 'which', [CompletionResultType]::ParameterValue, 'Display which binary will be run for a given command')
                [CompletionResult]::new('doc', 'doc', [CompletionResultType]::ParameterValue, 'Open the documentation for the current toolchain')
                [CompletionResult]::new('self', 'self', [CompletionResultType]::ParameterValue, 'Modify the rustup installation')
                [CompletionResult]::new('set', 'set', [CompletionResultType]::ParameterValue, 'Alter rustup settings')
                [CompletionResult]::new('completions', 'completions', [CompletionResultType]::ParameterValue, 'Generate tab-completion scripts for your shell')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
                break
            }
            'rustup;help;dump-testament' {
                break
            }
            'rustup;help;show' {
                [CompletionResult]::new('active-toolchain', 'active-toolchain', [CompletionResultType]::ParameterValue, 'Show the active toolchain')
                [CompletionResult]::new('home', 'home', [CompletionResultType]::ParameterValue, 'Display the computed value of RUSTUP_HOME')
                [CompletionResult]::new('profile', 'profile', [CompletionResultType]::ParameterValue, 'Show the default profile used for the `rustup install` command')
                break
            }
            'rustup;help;show;active-toolchain' {
                break
            }
            'rustup;help;show;home' {
                break
            }
            'rustup;help;show;profile' {
                break
            }
            'rustup;help;install' {
                break
            }
            'rustup;help;uninstall' {
                break
            }
            'rustup;help;update' {
                break
            }
            'rustup;help;check' {
                break
            }
            'rustup;help;default' {
                break
            }
            'rustup;help;toolchain' {
                [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List installed toolchains')
                [CompletionResult]::new('install', 'install', [CompletionResultType]::ParameterValue, 'Install or update a given toolchain')
                [CompletionResult]::new('uninstall', 'uninstall', [CompletionResultType]::ParameterValue, 'Uninstall a toolchain')
                [CompletionResult]::new('link', 'link', [CompletionResultType]::ParameterValue, 'Create a custom toolchain by symlinking to a directory')
                break
            }
            'rustup;help;toolchain;list' {
                break
            }
            'rustup;help;toolchain;install' {
                break
            }
            'rustup;help;toolchain;uninstall' {
                break
            }
            'rustup;help;toolchain;link' {
                break
            }
            'rustup;help;target' {
                [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List installed and available targets')
                [CompletionResult]::new('add', 'add', [CompletionResultType]::ParameterValue, 'Add a target to a Rust toolchain')
                [CompletionResult]::new('remove', 'remove', [CompletionResultType]::ParameterValue, 'Remove a target from a Rust toolchain')
                break
            }
            'rustup;help;target;list' {
                break
            }
            'rustup;help;target;add' {
                break
            }
            'rustup;help;target;remove' {
                break
            }
            'rustup;help;component' {
                [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List installed and available components')
                [CompletionResult]::new('add', 'add', [CompletionResultType]::ParameterValue, 'Add a component to a Rust toolchain')
                [CompletionResult]::new('remove', 'remove', [CompletionResultType]::ParameterValue, 'Remove a component from a Rust toolchain')
                break
            }
            'rustup;help;component;list' {
                break
            }
            'rustup;help;component;add' {
                break
            }
            'rustup;help;component;remove' {
                break
            }
            'rustup;help;override' {
                [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List directory toolchain overrides')
                [CompletionResult]::new('set', 'set', [CompletionResultType]::ParameterValue, 'Set the override toolchain for a directory')
                [CompletionResult]::new('unset', 'unset', [CompletionResultType]::ParameterValue, 'Remove the override toolchain for a directory')
                break
            }
            'rustup;help;override;list' {
                break
            }
            'rustup;help;override;set' {
                break
            }
            'rustup;help;override;unset' {
                break
            }
            'rustup;help;run' {
                break
            }
            'rustup;help;which' {
                break
            }
            'rustup;help;doc' {
                break
            }
            'rustup;help;self' {
                [CompletionResult]::new('update', 'update', [CompletionResultType]::ParameterValue, 'Download and install updates to rustup')
                [CompletionResult]::new('uninstall', 'uninstall', [CompletionResultType]::ParameterValue, 'Uninstall rustup.')
                [CompletionResult]::new('upgrade-data', 'upgrade-data', [CompletionResultType]::ParameterValue, 'Upgrade the internal data format.')
                break
            }
            'rustup;help;self;update' {
                break
            }
            'rustup;help;self;uninstall' {
                break
            }
            'rustup;help;self;upgrade-data' {
                break
            }
            'rustup;help;set' {
                [CompletionResult]::new('default-host', 'default-host', [CompletionResultType]::ParameterValue, 'The triple used to identify toolchains when not specified')
                [CompletionResult]::new('profile', 'profile', [CompletionResultType]::ParameterValue, 'The default components installed with a toolchain')
                [CompletionResult]::new('auto-self-update', 'auto-self-update', [CompletionResultType]::ParameterValue, 'The rustup auto self update mode')
                break
            }
            'rustup;help;set;default-host' {
                break
            }
            'rustup;help;set;profile' {
                break
            }
            'rustup;help;set;auto-self-update' {
                break
            }
            'rustup;help;completions' {
                break
            }
            'rustup;help;help' {
                break
            }
        })

    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
    Sort-Object -Property ListItemText
}
