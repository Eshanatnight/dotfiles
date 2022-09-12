$url = "https://gist.githubusercontent.com/Eshanatnight/506ee5fd07aef19f26b4cdebd987979b/raw/16c96b2a56aab72e0316ddbd2371801346e1e33a/premake5.lua"

if(!(Test-Path .\premake5.lua))
{
    New-Item .\premake5.lua -ItemType File -Force
}
Invoke-WebRequest $url -OutFile "premake5.lua"