<#
    tb .\file
    Get-Content .\file | nc termbin.com 9999
#>

if($args.Count -eq 1)
{
    Get-Content $args[0] | nc.exe termbin.com 9999;
}

else
{
    Write-Error "Incorrect Useage: ";
    Write-Error " tb .\path_to_file";
}