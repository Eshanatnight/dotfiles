using namespace System.Management.Automation
using namespace System.Management.Automation.Language

if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadLine
}

Import-Module -Name Terminal-Icons

C:\Users\eshan\AppData\Local\Programs\oh-my-posh\bin\oh-my-posh.exe --init `
        --shell pwsh `
        --config D:\Tweaks\oh-my-posh\ohmyposhv3-v2.json | Invoke-Expression

# makes use of the arrow keys to select the options from the terminal history
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward


# Insert text from the clipboard as a here string
Set-PSReadLineKeyHandler -Key Ctrl+V `
                        -BriefDescription PasteAsHereString `
                        -LongDescription "Paste the clipboard text as a here string" `
                        -ScriptBlock {
    param($key, $arg)

    Add-Type -Assembly PresentationCore
    if ([System.Windows.Clipboard]::ContainsText())
    {
        # Get clipboard text - remove trailing spaces, convert \r\n to \n, and remove the final \n.
        $text = ([System.Windows.Clipboard]::GetText() -replace "\p{Zs}*`r?`n","`n").TrimEnd()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("@'`n$text`n'@")
    }
    else
    {
        [Microsoft.PowerShell.PSConsoleReadLine]::Ding()
    }
}


$global:PSReadLineMarks = @{}

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

$envCMAKE_TOOLCHAIN_FILE="D:/tools/vcpkg/scripts/buildsystems/vcpkg.cmake"
