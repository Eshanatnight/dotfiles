if(!(Test-Path .\LICENSE))
{
    New-Item .\LICENSE -ItemType File -Force
}

Invoke-WebRequest "https://raw.githubusercontent.com/Eshanatnight/dotfiles/main/LICENSE" -OutFile ".\LICENSE"

if(!(Test-Path .\LICENSE))
{
    Write-Error "Failed to Create LICENSE file";
    exit;
}

#-----------------------------------------------------------------------------#

if(!(Test-Path .\.gitignore))
{
    New-Item .\.gitignore -ItemType File -Force
}

Invoke-WebRequest "https://gist.githubusercontent.com/Eshanatnight/2b152fe2f8f80ac257049ee8d72b4238/raw/13c62c639dd124382c273564aadb404cb8df3669/.gitignore" -OutFile ".\.gitignore"

if(!(Test-Path .\.gitignore))
{
    Write-Error "Failed to Create .gitignore file";
    exit;
}

#-----------------------------------------------------------------------------#

if(!(Test-Path .\.gitattributes))
{
    New-Item .\.gitattributes -ItemType File -Force
}

Invoke-WebRequest "https://gist.githubusercontent.com/Eshanatnight/21a297de28581ff8fa2b50fba59fd163/raw/3b85d477a79360dae67950de178f4dc5ee3f8333/.gitattributes" -OutFile ".\.gitattributes"

if(!(Test-Path .\.gitattributes))
{
    Write-Error "Failed to Create .gitattributes file";
    exit;
}

#-------------------------------------------------------------------------#

if(!(Test-Path .\.clang-format))
{
    New-Item .\.clang-format -ItemType File -Force
}

Invoke-WebRequest "https://gist.githubusercontent.com/Eshanatnight/ca162e562c7a0a53aebcc758b907f5f0/raw/72da840ce4bff61044e310af2c3b90f7f59d993a/.clang-format" -OutFile ".\.clang-format"

if(!(Test-Path .\.clang-format))
{
    Write-Error "Failed to Create .clang-format file";
    exit;
}

#-------------------------------------------------------------------------#

if(!(Test-Path .\vcpkg.json))
{
    New-Item .\vcpkg.json -ItemType File -Force
}
Invoke-WebRequest "https://gist.githubusercontent.com/Eshanatnight/04e2babf3a774b21a12896ada50836b3/raw/725527ca384728fb4ac00d1809b81ad4cdb9b322/vcpkg.json" -OutFile "vcpkg.json"

if(!(Test-Path .\vcpkg.json))
{
    Write-Error "Failed to Create vcpkg.json file";
    exit;
}

#-------------------------------------------------------------------------#

if(!(Test-Path .\premake5.lua))
{
    New-Item .\premake5.lua -ItemType File -Force
}
Invoke-WebRequest "https://gist.githubusercontent.com/Eshanatnight/506ee5fd07aef19f26b4cdebd987979b/raw/16c96b2a56aab72e0316ddbd2371801346e1e33a/premake5.lua" -OutFile "premake5.lua"

if(!(Test-Path .\premake5.lua))
{
    Write-Error "Failed to Create premake5.lua file";
    exit;
}

#-------------------------------------------------------------------------#

if(!(Test-Path .\.clang-tidy))
{
    New-Item .\.clang-tidy -ItemType File -Force
}
Invoke-WebRequest "https://gist.githubusercontent.com/Eshanatnight/2ef501048a515c5231fbc795a5369ed2/raw/19fcec1e007f28dbadc6cdb1bde076c3c087d8b2/.clang-tidy" -OutFile ".clang-tidy"

if(!(Test-Path .\.clang-tidy))
{
    Write-Error "Failed to Create .clang-tidy file";
    exit;
}

