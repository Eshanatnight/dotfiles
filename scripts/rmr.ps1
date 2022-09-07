$argsLen = $args.Count

if ($argsLen -eq 0)
{
    Write-Error "Invalid Arguments";
    Write-Error "Expected One argument path";
    Write-Error "Useage: rmr `"path-to-object`"";
    exit
}

if ($argsLen -gt 0)
{
    for(($i = 0); $i -lt $argsLen; $i++)
    {
        $path = $args[$i];
        if (Test-Path $path)
        {
            Remove-Item -r -Force $path;
        }

        else
        {
            Write-Error "Invalid Path";
            Write-Error "Expected a proper path";
            exit;
        }
    }
}


