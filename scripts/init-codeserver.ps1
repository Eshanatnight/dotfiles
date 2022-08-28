New-Item "$HOME\.vscode-server-launcher\bin" -ItemType "directory" -Force
Invoke-WebRequest "https://aka.ms/vscode-server-launcher/x86_64-pc-windows-msvc" -OutFile "$HOME\.vscode-server-launcher\bin\code-server.exe"
[Environment]::SetEnvironmentVariable("Path", [Environment]::GetEnvironmentVariable("Path", "User") + ";$HOME\.vscode-server-launcher\bin", "User")