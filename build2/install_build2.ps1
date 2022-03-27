cd d:;
mkdir build2-build2;
cd build2-build2;
mkdir build2-MSVC;
cd build2-MSVC;
certutil -hashfile build2-install-msvc-0.14.0.bat SHA256
.\build2-install-msvc-0.14.0.bat