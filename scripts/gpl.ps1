if(!(Test-Path .\premake5.lua))
{
    New-Item .\premake5.lua -ItemType File -Force
}
Invoke-WebRequest "https://gist.githubusercontent.com/Eshanatnight/506ee5fd07aef19f26b4cdebd987979b/raw/1f453bb606bd67974759de0e458676fff220f532/premake5.lua" -OutFile "premake5.lua"