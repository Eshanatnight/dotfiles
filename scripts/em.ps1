# shorthand for running the android emulator

if ($args.Count -gt 0) {
    Write-Error "No arguments are allowed";
    exit;
}

elseif ($args.Count -eq 0) {
    Start-Process -FilePath "C:/Users/eshan/AppData/Local/Android/Sdk/emulator/emulator" -ArgumentList "-avd Nexus_6P_API_29" -NoNewWindow -Wait;
}

else {
    Write-Error "Unkonwn error in script";
}