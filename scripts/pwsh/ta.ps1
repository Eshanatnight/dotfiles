# tar archive

$argsCount = $args.Count;

$useage = "ta outfilename /path/to directory"

if($argsCount -eq 0)
{
    Write-Error "Error Invalid Useage";
    Write-Output "Useage:";
    Write-Output $useage;
    exit;
}

elseif($argsCount -gt 0 -or $argsCount -lt 3)
{
    $filename = $args[0] + ".tar.gz";
    $path = $args[1];
    $parms = "-czvf " + $filename + " ";

    if(Test-Path $path)
    {
        $arr = $path.split('\');

        $dirName = $arr[1];
        $parms = $parms + $dirName;
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

