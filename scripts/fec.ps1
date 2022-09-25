$argsLen = $args.Count

if ($argsLen -le 1) {
    Write-Host "Usage: cpf.ps1 <origin> <destination> <flag> ..."
    Write-Host "Flags: -File or -Directory"
    exit
}

elseif ($argsLen -eq 3) {
    $origin = $args[0]
    $dest = $args[1]
    $flags = $args[2]


    if ($flags -eq "-File") {
        #Copy all the files to destination
        Get-ChildItem -Path $origin -File | foreach {
            Copy-Item $_.FullName -Destination $dest\$_FileName -Force
        }
    }

    elseif ($flags -eq "-Directory") {
        Get-ChildItem -Path $origin -Directory | foreach {
            Copy-Item $_.FullName -Destination $dest -Force -Recurse
        }
    }
}

else {
    Write-Host "Usage: cpf.ps1 <origin> <destination> <flag> ..."
    Write-Host "Flags: -File or -Directory"
    exit
}