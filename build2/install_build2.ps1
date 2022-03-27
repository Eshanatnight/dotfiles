mkdir "D:\build2-build2\build2-MSVC";
Copy-Item .\build2-install-msvc-0.14.0.bat "D:\build2-build2\build2-MSVC";
Set-Location D:\build2-build2\build2-MSVC;
certutil -hashfile build2-install-msvc-0.14.0.bat SHA256;
.\build2-install-msvc-0.14.0.bat;