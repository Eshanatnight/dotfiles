# a script to write some common files to local from the internet

$useage = "`nUseage: `n`nal`nor`nal <option>`n`nOptions:`n--all or -a";
if ($args.Count -gt 0)
{
    Write-Error "Invalid Useage"
    Write-Error "$useage"
    exit
}

$isRust = Test-Path .\Cargo.toml
$isCXX = (Test-Path .\CmakeLists.txt) -or (Test-Path ".\*.sln") -or (Test-Path ".\*.vcxproj")

# General files
function getLicense {
    New-Item .\LICENSE -ItemType File -Force
    Invoke-WebRequest "https://raw.githubusercontent.com/Eshanatnight/dotfiles/main/LICENSE" -OutFile ".\LICENSE"

    if(!(Test-Path .\LICENSE)) {
        Write-Error "Failed to Create LICENSE file";
        exit;
    }
}

function getGitFiles {

    if(-not $isRust)
    {
        New-Item .\.gitignore -ItemType File -Force
        Invoke-WebRequest "https://gist.githubusercontent.com/Eshanatnight/2b152fe2f8f80ac257049ee8d72b4238/raw/13c62c639dd124382c273564aadb404cb8df3669/.gitignore" -OutFile ".\.gitignore"

        if(!(Test-Path .\.gitignore)) {
            Write-Error "Failed to Create .gitignore file";
            exit;
        }
    }


    New-Item .\.gitattributes -ItemType File -Force
    Invoke-WebRequest "https://gist.githubusercontent.com/Eshanatnight/21a297de28581ff8fa2b50fba59fd163/raw/3b85d477a79360dae67950de178f4dc5ee3f8333/.gitattributes" -OutFile ".\.gitattributes"

    if(!(Test-Path .\.gitattributes)) {
        Write-Error "Failed to Create .gitattributes file";
        exit;
    }
}

getLicense
getGitFiles

if($isRust) {
    # if Cargo.toml exists download the rustfmt file
    # if the file already exists just overwrite it
    New-Item .\rustfmt.toml -ItemType File -Force
    Invoke-WebRequest "https://gist.githubusercontent.com/Eshanatnight/92e775458ce47910d908b8e80d9e0d2f/raw/eede8a414cde20a343b706ae34aef5106540da9e/rustfmt.toml" -OutFile ".\rustfmt.toml";

    if(!(Test-Path .\rustfmt.toml)) {
        Write-Error "Failed to Create rustfmt.toml file";
        exit;
    }
}

if($isCXX) {
    New-Item .\.clang-format -ItemType File -Force
    Invoke-WebRequest "https://gist.githubusercontent.com/Eshanatnight/ca162e562c7a0a53aebcc758b907f5f0/raw/72da840ce4bff61044e310af2c3b90f7f59d993a/.clang-format" -OutFile ".\.clang-format";
    if(!(Test-Path .\.clang-format)){
        Write-Error "Failed to Create .clang-format file";
        exit;
    }

    New-Item .\vcpkg.json -ItemType File -Force
    Invoke-WebRequest "https://gist.githubusercontent.com/Eshanatnight/04e2babf3a774b21a12896ada50836b3/raw/725527ca384728fb4ac00d1809b81ad4cdb9b322/vcpkg.json" -OutFile "vcpkg.json";
    if(!(Test-Path .\vcpkg.json)) {
        Write-Error "Failed to Create vcpkg.json file";
        exit;
    }

    New-Item .\premake5.lua -ItemType File -Force
    Invoke-WebRequest "https://gist.githubusercontent.com/Eshanatnight/506ee5fd07aef19f26b4cdebd987979b/raw/16c96b2a56aab72e0316ddbd2371801346e1e33a/premake5.lua" -OutFile "premake5.lua";
    if(!(Test-Path .\premake5.lua)) {
        Write-Error "Failed to Create premake5.lua file";
        exit;
    }

    New-Item .\.clang-tidy -ItemType File -Force
    Invoke-WebRequest "https://gist.githubusercontent.com/Eshanatnight/2ef501048a515c5231fbc795a5369ed2/raw/19fcec1e007f28dbadc6cdb1bde076c3c087d8b2/.clang-tidy" -OutFile ".clang-tidy";
    if(!(Test-Path .\.clang-tidy))
    {
        Write-Error "Failed to Create .clang-tidy file";
        exit;
    }
}
