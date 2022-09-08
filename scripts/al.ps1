New-Item .\LICENSE -ItemType File -Force;
Invoke-WebRequest "https://raw.githubusercontent.com/Eshanatnight/dotfiles/main/LICENSE" -OutFile .\LICENSE

if(!(Test-Path .\LICENSE))
{
    Write-Error "Failed to Create LICENSE file";
    exit;
}


if(!(Test-Path .\.gitignore))
{
    New-Item .\.gitignore -ItemType File -Force
}
Invoke-WebRequest "https://gist.githubusercontent.com/Eshanatnight/2b152fe2f8f80ac257049ee8d72b4238/raw/13c62c639dd124382c273564aadb404cb8df3669/.gitignore" -OutFile .\.gitignore
if(!(Test-Path .\.gitignore))
{
    Write-Error "Failed to Create .gitignore file";
    exit;
}

if(!(Test-Path .\.gitattributes))
{
    New-Item .\.gitattributes -ItemType File -Force
}
Invoke-WebRequest "https://gist.githubusercontent.com/Eshanatnight/21a297de28581ff8fa2b50fba59fd163/raw/3b85d477a79360dae67950de178f4dc5ee3f8333/.gitattributes" -OutFile .\.gitattributes

New-Item .\.clang-format -ItemType File -Force
Invoke-WebRequest "https://gist.githubusercontent.com/Eshanatnight/ca162e562c7a0a53aebcc758b907f5f0/raw/72da840ce4bff61044e310af2c3b90f7f59d993a/.clang-format" -OutFile .\.clang-format
if(!(Test-Path .\.clang-format))
{
    Write-Error "Failed to Create .clang-format file";
    exit;
}
