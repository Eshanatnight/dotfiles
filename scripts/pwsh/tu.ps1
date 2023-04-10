# Tar Unarchive

$argsCount = $args.Count;

$useage = "tc /path/to/archive"

if($argsCount -eq 0)
{
    Write-Error "Error Invalid Useage";
    Write-Output "Useage:";
    Write-Output $useage;
    exit;
}

elseif($argsCount -eq 1)
{
    $path = $args[0];
    $parms = "-xvf " + $path;

    if(Test-Path $args[0])
    {
        Start-Process tar -ArgumentList $parms -NoNewWindow -Wait
    }
    else
    {
        Write-Error "Error Invalid Useage";
        Write-Output "Useage:";
        Write-Output $useage;
        exit;
    }
}

