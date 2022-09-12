$url = "https://gist.githubusercontent.com/Eshanatnight/04e2babf3a774b21a12896ada50836b3/raw/5bd405df5bacecf2740168521b98700ce624d403/vcpkg.json"

if(!(Test-Path .\vcpkg.json))
{
    New-Item .\vcpkg.json -ItemType File -Force
}
Invoke-WebRequest $url -OutFile "vcpkg.json"