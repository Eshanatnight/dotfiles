# Windows Terminal

Contains all the stuff need for windows terminal.

## Contains

- [settings.json](".\settings.json")
- [Powershell Folder](".\Powershell")

## settings.json

contains the settings for the terminal. Themes, colors, etc.

## Powershell Folder

- [Powershell_Profile](./Powershell/Microsoft.PowerShell_profile.ps1)
- [setup](./Powershell/setup-windows-terminal.ps1)
- [theme](./Powershell/Theme/)

## Removed Settings from Windows Terminal

Settings that are removed from the [settings.json](./settings.json) of the Windows Terminal.

```json
{
    "profiles":{
        "list": [
            // ? Visual Studio 22 Developer Command Prompt
            {
                "guid": "{8f66ee14-da20-5f6f-999d-13d44efac5d8}",
                "hidden": false,
                "name": "Developer Command Prompt for VS 2022",
                "source": "Windows.Terminal.VisualStudio"
            },
            // ? Windows Azure Shell
            {
                "guid": "{b453ae62-4e3d-5e58-b989-0a998ec441b8}",
                "hidden": true,
                "name": "Azure Cloud Shell",
                "source": "Windows.Terminal.Azure"
            },
            // ? Old Developer PowerShell - Depricate
            {
                "colorScheme": "xcad_tdl",
                "commandline": "powershell.exe -NoExit -Command \"&{ $vsInstallPath=& \"${env:ProgramFiles(x86)}/'Microsoft Visual Studio'/Installer/vswhere.exe\" -prerelease -latest -property installationPath; Import-Module \"$vsInstallPath/Common7/Tools/Microsoft.VisualStudio.DevShell.dll\"; Enter-VsDevShell -VsInstallPath $vsInstallPath -SkipAutomaticLocation }\"",
                "cursorColor": "#FF0095",
                "cursorShape": "bar",
                "guid": "{00000000-0000-0000-0000-000000a12345}",
                "icon": "ms-appx:///ProfileIcons/{61c54bbd-c2c6-5271-96e7-009a87ff44bf}.png",
                "name": "Developer PowerShell",
                "tabTitle": "Developer Powershell",
                "hidden": true
            },
            // ? Powershell
            {
                "colorScheme": "xcad_tdl",
                "cursorColor": "#FFCC00",
                "cursorShape": "bar",
                "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
                "hidden": true,
                "name": "Windows PowerShell",
                "opacity": 50,
                "useAcrylic": true
            },
            // ? Command Prompt
            {
                "colorScheme": "One Half Dark",
                "cursorColor": "#FFCC00",
                "cursorShape": "bar",
                "guid": "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}",
                "hidden": true,
                "name": "Command Prompt",
                "opacity": 25,
                "useAcrylic": true
            }
        ]
    }
}
```
