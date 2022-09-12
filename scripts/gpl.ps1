if(!(Test-Path .\premake5.lua))
{
    New-Item .\premake5.lua -ItemType File -Force
}
Invoke-WebRequest "https://gist.githubusercontent.com/Eshanatnight/506ee5fd07aef19f26b4cdebd987979b/raw/ef4f08eb12eec87dc48c999e02daa90feb79b4f8/premake5.lua" -OutFile "premake5.lua"