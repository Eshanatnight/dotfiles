# Configure a WSL Toolchain

1. In CLion, go to Settings / Preferences | Build, Execution, Deployment | Toolchains.

2. Click plus icon to create a new toolchain and select WSL.

3.In the Environment field, select one of the available WSL distributions. The list includes the distributions detected by wsl.exe --list, which includes the imported ones.

4. Now to start using the toolchain, do the following:

    - CMake
    - Makefile