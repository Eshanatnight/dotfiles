# Windows

## Installing Applications without Admin Privilages

Create a Folder with whatever name. Move the installer executable to that folder. Create a new batch script. The name of the file does not matter necessarily, but it is adviced to follow convention and call it `setup.bat`

### Contents of the `setup.bat` script

`filename: setup.bat`
```batch
set __COMPAT_LAYER=RunAsInvoker
start <name_of_installer>
```

---

## CPP in Windows

### Visual Studio

> My Visual Studio Directory Setup
>
> Output Dir: `$(SolutionDir)bin\$(Platform)\$(Configuration)\`
> 
> Intermideates Dir: `$(SolutionDir)bin\intermideates\$(Platform)\$(Configuration)\`
> 
> Additional Include Directory: `$(SolutionDir)src\include,$(SolutionDir)include`

#### Visual C++ Compiler stdc++=20

##### Installation guide

~ Install Visual Sudio

~ Modify Installation

~ Individual Components > search ` modules `

##### Activation

* Solution Properties > Configuration Properties > General: C++ Language Standard = "Preview - Features from the Latest C++ Working Draft (/std:c++latest)"

* Solution Properties > C/C++ > Language : Enable External C++ Standard Library Modules = "Yes(/experimental:module)"

##### import commands

* std.filesystem -> `<filesystem>`
* std.regex -> `<regex>`
* std.memory -> `<memory>`
* std.threading -> `<atomic>, <condition_variable>, <future>, <mutex>, <shared_mutex> and <thread>`
* std.core -> Everything else in the Standard Library

> Note: -> = Provides the contents of headers
>
> CPP Standard Core Guidelines Ammended to just use `import std` rather than the above.
>
> Possibly by the time you are reading this, stdc++20 uses `import std;`

---

### Installing & Updating the MSYS2 toolchain

To update the MSYS2-MINGW toolchain just run the following command in the MSYS2 bash shell.

```terminal
pacman -Syu

pacman -S -u mingw-w64-x86_64-toolchain
```

To update the MSYS2-clang toolchain just run the following command in the MSYS2 bash shell.

```terminal
pacman -Syu

pacman -S -u mingw-w64-clang-x86_64-toolchain
```

---

### vcpkg

#### Installing `vcpkg`

To install ***vcpkg*** you can run the [script](../scripts/upgrade-vcpkg.ps1). It's a
Poweshell Script that will clone the repository from the
[official page](https://github.com/microsoft/vcpkg.git) in the location `D:\tools\vcpkg`
and then bootstrapping vcpkg.

> Note: You would need to add the executable to env PATH, if you want to use it globally in the terminal

---

#### Using vcpkg

##### ***vcpkg*** in Global Mode

Navigate to the project repository. Create a build directory `build`, or whatever you want to name.
Navigate to the build Directory.

```terminal
mkdir build

cd build
```

```terminal
cmake .. -DCMAKE_TOOLCHAIN_FILE=<path-to-vcpkg>/scripts/buildsystems/vcpkg.cmake
```

```terminal
cmake --build .
```

> Note: if you are using the Visual Studio compiler,
> and you are using the cmake cli to build your application.
>
> Then to get the release build of the project.
> You need to pass `--release` flag in the build command. 
>
> Like so

```terminal
cmake --build . --release
```

---

##### ***vcpkg*** in Manifest Mode

vcpkg has now a mainfest mode. To use it, you need a manifest file `vcpkg.json` in the
place where the top level `CMakelists.txt` file is.

###### Format for `vcpkg.json`

`filename: vcpkg.json`
```json
{
    "name": "Project_Name",
    "version-string": "0.0.1",
    "description": "Project_Description",

    "dependencies":
    [
        "name_of_package",
        {
            "name": "name_of_package",
            "features": [ "feature_name" ]
        }
    ]
}
```

To use CMake and vcpkg in Manifest Mode. Add the following to the vscode `settings.json` file.

`filename: .vscode/settings.json`
```json
"cmake.configureSettings": {
        "CMAKE_TOOLCHAIN_FILE": "path/to/vcpkg/scripts/buildsystems/vcpkg.cmake"
}
"cmake.configureOnOpen": true
```

---

## Rust Toolchain on Windows

To update the rust toolchain just run the following command.

```terminal
rustup update
```

After completion the Rust Toolchain will be updated.

---

## Jetbrains IDE Settings

1. For [CLion](../.jetbrains-settings/CLion)
2. For [Idea](../.jetbrains-settings/Idea)
3. For [Visual Studio](../.visual-studio-settings)

---
