<#
Title:       Filename Search
Description: Search for files in a directory tree, including hidden files.
#>

$args | ForEach-Object { $_*2 }
Clear-Host
if ($args.Count -ne 1)
{
    Write-Host "Usage: .\Filename_Search_CSV.ps1 <directory_path>"
    exit
}

$directory_path = $args[0]

Set-Location $directory_path

$file_name = "*"

$output_directory = "C:\"

$result_fileName = (Get-Date -Format "dddd-MMM-dd-yyyy--hh.mm.ss.tt") + ".csv"

Get-ChildItem -Force -Path $directory_path -Filter $file_name -Recurse | Where-Object { !$_.PSIsContainer } |
Select-Object FullName, LastWriteTime, Length | Sort-Object FullName |
Export-Csv -NoTypeInformation -Path $output_directory\$result_fileName | ForEach-Object {$_.Replace('"','')}

Invoke-Item -Path $output_directory\$result_fileName