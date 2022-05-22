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

</br>

# Visual C++ Compiler stdc++=20

    ## Installation guide
        ~ Install Visual Sudio
        ~ Modify Installation
        ~ Individual Components > search ``` modules ```

    ## Activation
    ~ Solution Properties > Configuration Properties > General
        -> C++ Language Standard = "Preview - Features from the Latest C++ Working Draft (/std:c++latest)"

    ~ Solution Properties > C/C++ > Language >
        -> Enable External C++ Standard Library Modules = "Yes(/experimental:module)"

    ## import commands
        ~ std.filesystem -> <filesystem>
        ~ std.regex -> <regex>
        ~ std.memory -> <memory>
        ~ std.threading -> <atomic>, <condition_variable>, <future>, <mutex>, <shared_mutex> and <thread>
        ~ std.core -> Everything else in the Standard Library

        Note: -> = Provides the contents of headers

