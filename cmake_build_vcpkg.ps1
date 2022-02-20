mkdir build
Set-Location build
cmake .. -DCMAKE_TOOLCHAIN_FILE=D:/Program Files/vcpkg/scripts/buildsystems/vcpkg.cmake
cmake --build .
