# take will create a new directory and change into it
[string]$useage = "Usage: take <directory>";


function take {
    param(
        [Parameter(Mandatory = $true)]
        [string]$directory
    )

    New-Item -ItemType Directory -Force -Path $directory | Out-Null;
    Set-Location $directory;
}

if ($args.Length -eq 1) {
    take $args[0]
    exit;
}

elseif ($args.Length -eq 0 -or $args.Length -gt 1) {
    <# Action when this condition is true #>
    Write-Host $useage;
    exit;
}
