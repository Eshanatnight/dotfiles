$argsCount = $args.Count;

$useage = "tc outfilename /path/to directory"

if($argsCount -eq 0)
{
    Write-Error "Error Invalid Useage";
    Write-Output "Useage:";
    Write-Output $useage;
    exit;
}

elseif ($argsCount -eq 1)
{
    if(Test-Path $args[0])
    {
        $p = $args[0];
        $path;
        if($p.Substring($p.Length -1) -eq "\")
        {
            $idx = $args[0].Length - 1;
            $path = $p.Substring(0, $idx);
        }

        $filename = $path.Split("\");
        $correctIdx = $filename.Count - 1;
        $dir = $filename[$correctIdx];

        $parms = "-czvf " + $dir + ".tar.gz " + $path;
        Start-Process tar -ArgumentList $parms -NoNewWindow -Wait
    }
    else
    {
        Write-Error "Error Useage";
        Write-Error "tc /path/to directory";
    }
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

