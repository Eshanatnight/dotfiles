<#
    * How this should work
    ir "https://github.com/xxxx/xxxxx.git"
    this should expand to
    git remote add origin "https://github.com/xxxx/xxxxx.git"

    * Then change the branch name to main
#>

# Declare the global variables cause convinience
$error_msg = "Invalid useage `n`Useage: ir <git_repository_url>"

$argsLen = $args.Count;

# if no args are provided
if ($argsLen -eq 0)
{
    Write-Error $error_msg;
    exit;
}

elseif ($argsLen -eq 1)
{
    $repository = $args[0];
    Start-Process git -ArgumentList "remote add origin ${repository}" -NoNewWindow -Wait
}

elseif ($argsLen -gt 1)
{
    Write-Error "Too many arguments passed`n";
    Write-Error $error_msg;
    exit;
}

else
{
    Write-Error $error_msg;
}
