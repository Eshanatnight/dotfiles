winget install JanDeDobbeleer.OhMyPosh;
if($?)
{
    C:\Users\eshan\AppData\Local\Programs\oh-my-posh\bin\oh-my-posh.exe;
    if($?)
    {
        mkdir C:\Users\eshan\Documents\PowerShell;
        if($?)
        {
            Write-Output "C:\Users\eshan\AppData\Local\Programs\oh-my-posh\bin\oh-my-posh.exe --init --shell pwsh --config ~/jandedobbeleer.omp.json | Invoke-Expression" > C:\Users\eshan\Documents\PowerShell\Microsoft.PowerShell_profile.ps1;
            if($?)
            {
                code C:\Users\eshan\Documents\PowerShell\Microsoft.PowerShell_profile.ps1;
                # copy the contents of the theme file (theme?) at this point to the opened file
                if ($?)
                {
                    Install-Module -Name Terminal-Icons -Repository PSGallery;
                    if($?)
                    {
                        Import-Module -Name Terminal-Icons;
                        # to test if the icons are working properly or not.
                        if($?)
                        {
                            Install-Module -Name PSReadLine -RequiredVersion 2.2.0-beta1 -AllowPrerelease
                            # installed PreReleaseversion for List View Functionality
                        }
                    }
                }
            }
        }
    }
}


