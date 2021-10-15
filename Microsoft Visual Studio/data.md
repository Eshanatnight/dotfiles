# Generel
    1. Output Dir: $(SolutionDir)bin\$(Platform)\$(Configuration)\
    2. Intermideates Dir: $(SolutionDir)bin\intermideates\$(Platform)\$(Configuration)\
    3. Additional Include Directory: $(SolutionDir)src\include,$(SolutionDir)include

</br>

# vcpkg
    ## Installation guide

        ```terminal
            > git clone https://github.com/microsoft/vcpkg
            > .\vcpkg\bootstrap-vcpkg.bat

        ```

    ## Configuration outside of Visual Studio

        In order to use vcpkg with CMake outside of an IDE, you can use the toolchain file:
        ```terminal
            > cmake -B [build directory] -S . -DCMAKE_TOOLCHAIN_FILE=[path to vcpkg]/scripts/buildsystems/vcpkg.cmake
            > cmake --build [build directory]
        ```