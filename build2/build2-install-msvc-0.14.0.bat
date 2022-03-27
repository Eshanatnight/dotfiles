@echo off

rem file      : build2-install-msvc.bat
rem license   : MIT; see the build2-toolchain/LICENSE file for details

setlocal EnableDelayedExpansion
set "prog=%~0"
goto start

:usage
echo.
echo Usage: %prog% [-h] [^<options^>] [^<install-dir^>]
echo Options:
echo   --yes                 Do not ask for confirmation before starting.
echo   --local               Don't build from packages, only from local source.
echo   --no-bpkg             Don't install bpkg nor bdep ^(requires --local^).
echo   --no-bdep             Don't install bdep.
echo   --no-modules          Don't install standard build system modules.
echo   --modules "<list>"    Install only specified standard build system modules.
echo   --exe-prefix ^<pfx^>    Toolchain executables name prefix.
echo   --exe-suffix ^<sfx^>    Toolchain executables name suffix.
echo   --stage-suffix ^<sfx^>  Staged executables name suffix ^('-stage' by default^).
echo   --jobs^|-j ^<num^>       Number of jobs to perform in parallel.
echo   --trust ^<fp^>          Repository certificate fingerprint to trust.
echo   --timeout ^<sec^>       Network operations timeout in seconds ^(600 by default^).
echo   --no-check            Do not check for a new script version.
echo   --upgrade             Upgrade previously installed toolchain.
echo   --uninstall           Uninstall previously installed toolchain.
echo.
echo By default this batch file will use C:\build2 as the installation directory
echo and the current working directory as the build directory.
echo.
echo If --jobs^|-j is unspecified, then the number of available hardware
echo threads is used.
echo.
echo The --trust option recognizes two special values: 'yes' ^(trust everything^)
echo and 'no' ^(trust nothing^).
echo.
echo The script by default installs the following standard build system
echo modules:
echo.
echo %standard_modules%
echo.
echo Use --no-modules to suppress installing build system modules or
echo --modules "<list>" to specify a comma-separated subset to install.
echo.
echo Note also that ^<options^> must come before the ^<install-dir^> argument.
echo.
goto end

rem Usage: call :set_exe_affix (prefix|suffix) DIR
rem
rem Extract the config.install.(prefix|suffix) value from config.build in the
rem specified configuration directory (assume it exists). Set the
rem exe_(prefix|suffix) variable to that value unless the user explicitly
rem specified this prefix/suffix, in which case verify they match.
rem
:set_exe_affix
  setlocal EnableDelayedExpansion

  set "c=%2\build\config.build"
  for /F "tokens=2 delims== " %%i in ('findstr "config.bin.exe.%1" %c%') do set "cv=%%i"

  set "vn=exe_%1"
  set "vv=!%vn%!"

  if "_%vv%_" == "__" (
    endlocal & set "%vn%=%cv%"
  ) else (
    if not "_%vv%_" == "_%cv%_" (
      echo.
      echo error: detected executables name %1 '%cv%' does not match specified '%vv%'
      endlocal
      exit /b 1
    )
    endlocal
  )
goto :eof

rem Usage: call :set_exe_names INSTALLED_ONLY
rem
rem Derive the to be installed executables names based on
rem --exe-{prefix,suffix} or config.bin.exe.{prefix,suffix}. Unless
rem INSTALLED_ONLY is true, also derive the staged executables names based
rem on --stage-suffix and verify that they don't clash with existing
rem filesystem entries as well the executables being installed. Assume that
rem the install root (idir) is already set.
rem
:set_exe_names
  rem Note that we only set the global variables in this function.
  rem
  set "b=%exe_prefix%b%exe_suffix%"
  set "bpkg=%exe_prefix%bpkg%exe_suffix%"
  set "bdep=%exe_prefix%bdep%exe_suffix%"

  if "_%1_" == "__" (
    set "b_stage=b%stage_suffix%"
    set "bpkg_stage=bpkg%stage_suffix%"

    if exist %idir%\bin\!b_stage!.exe (
      echo.
      echo error: staged executable name '!b_stage!' clashes with existing %idir%\bin\!b_stage!.exe
      echo   info: specify alternative staged executables name suffix with --stage-suffix
      exit /b 1
    )

    if exist %idir%\bin\!bpkg_stage!.exe (
      echo.
      echo error: staged executable name '!bpkg_stage!' clashes with existing %idir%\bin\!bpkg_stage!.exe
      echo   info: specify alternative staged executables name suffix with --stage-suffix
      exit /b 1
    )

    if "_%stage_suffix%_" == "_%exe_suffix%_" (
      if "_%exe_prefix%_" == "__" (
        echo.
        echo error: suffix '%exe_suffix%' is used for both final and staged executables
        echo   info: specify alternative staged executables name suffix with --stage-suffix
        exit /b 1
      )
    )
  )
goto :eof

rem Usage: call :checksum FILE VAR
rem
rem Calculate the SHA256 checksum of the specified file and store it in VAR.
rem
:checksum
  @setlocal EnableDelayedExpansion
  @for /F "tokens=*" %%i in ('@certutil -hashfile %1 SHA256 ^| findstr /v /C:"%1" ^| findstr /v "CertUtil"') do @set "_r=%%i"
  @if "_%_r%_" == "__" (
    echo error: unable to extract checksum from %1
    echo   info: using 'certutil -hashfile %1 SHA256'
    endlocal
    exit /b 1
  )
  @set "_r=%_r: =%"
  @endlocal & set "%2=%_r%"
@goto :eof

rem Usage: call :download URL FILE
rem
rem Download from the specified url and save the result to file.
rem
:download
  @setlocal EnableDelayedExpansion
  powershell.exe -nologo -noprofile -command "& { try{Invoke-WebRequest %1 -OutFile %2 -TimeoutSec %timeout%} catch {Write-Host $_.Exception.Message; Exit 1} }"
  @if errorlevel 1 (
    endlocal
    exit /b 1
  )
  @endlocal
@goto :eof

rem Usage: call :prompt_continue
rem
:prompt_continue

  if "_%yes%_" == "_true_" goto :eof

  set i=
  set /P i=Continue? [y/n]

  rem If nothing gets entered, set /P sets errorlevel to 1 so we have to
  rem clear it.
  rem
  if errorlevel 1 cmd /c "exit /b 0"

  if /I     "_%i%_" == "_n_" exit /b 1
  if /I not "_%i%_" == "_y_" goto prompt_continue
goto :eof

rem Usage: call :check_script
rem
rem Check if the script is out of date. See the POSIX shell version for
rem details on the logic.
rem
:check_script

  @if not "_%check%_" == "_true_" goto :eof

  @setlocal EnableDelayedExpansion

  @rem Download.
  @rem
  @set "f=%manifest%"
  @call :download %url%/%f% %f%
  @if errorlevel 1 (
    echo.
    echo info: toolchain manifest download failed, skipping script version check
    endlocal
    exit /b 0
  )

  @rem Calculate script's checksum.
  @rem
  @call :checksum %prog% prog_sum
  @if errorlevel 1 (
    endlocal
    exit /b 1
  )

  @rem Find our checksum line.
  @rem
  @for /F "tokens=*" %%i in ('@findstr "%stem%-" %f%') do @set "l=%%i"
  @if "_%l%_" == "__" (
    echo.
    echo error: unable to extract checksum for %stem%.bat from %f%
    endlocal
    exit /b 1
  )
  @del %f%

  @rem Extract the checksum.
  @rem
  @for /F "tokens=1" %%i in ("%l%") do @set "r=%%i"

  @if "_%r%_" == "_%prog_sum%_" (
    endlocal
    goto :eof
  )

  @rem Extract version and file.
  @rem
  @for /F "tokens=2 delims=* " %%i in ("%l%") do @set "f=%%i"
  @for /F "tokens=1 delims=/"  %%i in ("%f%") do @set "v=%%i"

  @if not "_%v%_" == "_%ver%_" (
    echo.
    echo Install script for version %v% is now available, download from:
    echo.
    echo   %url%/%f%
  ) else (
    echo.
    echo Install script %prog% is out of date:
    echo.
    echo Old checksum: %prog_sum%
    echo New checksum: %r%
    echo.
    echo Re-download from:
    echo.
    echo   %url%/%f%
    echo.
    echo Or use the --no-check option to suppress this check.
    echo.
    endlocal
    exit /b 1
  )

  @endlocal
@goto :eof

rem Usage: call :set_install_root DIR
rem
rem Extract the config.install.root value from config.build in the specified
rem configuration directory. Set idir to that value unless the user explicitly
rem specified the installation directory, in which case verify they match.
rem
:set_install_root
  setlocal EnableDelayedExpansion

  if not exist %1\ (
    echo.
    echo error: build configuration directory %1\ does not exist
    endlocal
    exit /b 1
  )

  set "c=%1\build\config.build"

  if not exist %c% (
    echo.
    echo error: directory %1\ does not contain a build configuration
    endlocal
    exit /b 1
  )

  rem Extract the installation directory from config.build. Note that the
  rem value will be single-quoted (due to backslashes) and will contain
  rem the trailing slash.
  rem
  for /F "tokens=2 delims='" %%i in ('findstr "config.install.root" %c%') do set "r=%%i"

  if "_%r%_" == "__" (
    echo.
    echo error: unable to extract installation directory from %c%
    endlocal
    exit /b 1
  )

  rem Get rid of the trailing slash (you didn't expect it to be easy, did you).
  rem
  for /F "delims=|" %%D in ("%r%x/..") do set "iname=%%~nxD"
  for /F "delims=|" %%D in ("%r%x/..") do set "ipath=%%~dpD"
  set "r=%ipath%%iname%"

  if not "_%idir%_" == "__" (
    if /I not "_%r%_" == "_%idir%_" (
      echo.
      echo error: detected installation directory does not match specified
      echo   info: detected  %r%
      echo   info: specified %idir%
      endlocal
      exit /b 1
    )
  )

  endlocal & set "idir=%r%"
goto :eof

rem Usage: call :install_time CORES VAR
rem
rem Calculate an approximate build2 toolchain build and installation time (in
rem seconds) if built with the specified number of cores and store it in VAR.
rem See build2-times.txt for details.
rem
:install_time
  setlocal EnableDelayedExpansion

          if %1 LSS  7 (set "_f=2529"
  ) else (if %1 LSS  9 (set "_f=1912"
  ) else (if %1 LSS 17 (set "_f=2300"
  ) else (if %1 LSS 33 (set "_f=3277"
  ) else               (set "_f=4759"))))

  set /A "_r=%_f% / %1"

  rem Windows fudge.
  rem
  set /A "_r=%_r% * 12 / 10"

  rem Local installation fudge.
  rem
  if "_%local%_" == "_true_" set /A "_r=%_r% * 7 / 10"

  endlocal & set "%2=%_r%"
goto :eof

:start

set "owd=%CD%"

set "ver=0.14.0"
set "type=public"

set "build2_ver=0.14.0"
set "bpkg_ver=0.14.0"
set "bdep_ver=0.14.0"

rem Standard modules comma-separated list and versions.
rem
rem NOTE: we currently print the list as a single line and will need to
rem somehow change that when it becomes too long.
rem
set "standard_modules=kconfig"
set "kconfig_ver=0.1.0"

set "url=https://download.build2.org"
set "repo=https://pkg.cppget.org/1/alpha"

set "toolchain=build2-toolchain-0.14.0"
set "toolchain_sum=18efc6b2d41498f7516e7a8a5c91023f6182c867d423792398390dd0c004cfdd"
set "utils=build2-baseutils-0.14.0-x86_64-windows"
set "utils_sum=8f1ce283175aa6e527ceac03b97a4f78b59684495bf0b10a3a3a440e7e4ffbab"

set "tdir=%toolchain%"

set "cver=0.14"
set "cdir=build2-toolchain-%cver%"

rem Empty if no upgrade is possible.
rem
set "pcver=0.13"
set "pcdir=build2-toolchain-%pcver%"

set "manifest=toolchain.sha256"
set "stem=build2-install-msvc"

rem Parse options and arguments.
rem
set "mode=install"

set "yes="
set "local="
set "bpkg_install=true"
set "bdep_install=true"
set "modules=%standard_modules%"
set "exe_prefix="
set "exe_suffix="
set "stage_suffix=-stage"
set "jobs="
set "trust="
set "check=true"
set "timeout=600"
set "connect_timeout=60"

set "idir="

:options
if "_%~1_" == "_/?_"     goto usage
if "_%~1_" == "_-h_"     goto usage
if "_%~1_" == "_--help_" goto usage

if "_%~1_" == "_--upgrade_" (
  set "mode=upgrade"
  shift
  goto options
)

if "_%~1_" == "_--uninstall_" (
  set "mode=uninstall"
  shift
  goto options
)

if "_%~1_" == "_--yes_" (
  set "yes=true"
  shift
  goto options
)

if "_%~1_" == "_--local_" (
  set "local=true"
  shift
  goto options
)

if "_%~1_" == "_--no-bpkg_" (
  set "bpkg_install="
  shift
  goto options
)

if "_%~1_" == "_--no-bdep_" (
  set "bdep_install="
  shift
  goto options
)

if "_%~1_" == "_--no-modules_" (
  set "modules="
  shift
  goto options
)

if "_%~1_" == "_--modules_" (
  set "modules=%~2"
  shift
  shift
  goto options
)

if "_%~1_" == "_--exe-prefix_" (
  if "_%~2_" == "__" (
    echo error: executables name prefix expected after --exe-prefix
    goto error
  )
  set "exe_prefix=%~2"
  shift
  shift
  goto options
)

if "_%~1_" == "_--exe-suffix_" (
  if "_%~2_" == "__" (
    echo error: executables name suffix expected after --exe-suffix
    goto error
  )
  set "exe_suffix=%~2"
  shift
  shift
  goto options
)

if "_%~1_" == "_--stage-suffix_" (
  if "_%~2_" == "__" (
    echo error: staged executables name suffix expected after --stage-suffix
    goto error
  )
  set "stage_suffix=%~2"
  shift
  shift
  goto options
)

set "jo="
if "_%~1_" == "_-j_"     set "jo=true"
if "_%~1_" == "_--jobs_" set "jo=true"

if "_%jo%_" == "_true_" (
  if "_%~2_" == "__" (
    echo error: number of jobs expected after --jobs^|-j
    goto error
  )
  set "jobs=%~2"
  shift
  shift
  goto options
)

if "_%~1_" == "_--trust_" (
  if "_%~2_" == "__" (
    echo error: certificate fingerprint expected after --trust
    goto error
  )
  set "trust=%~2"
  shift
  shift
  goto options
)

if "_%~1_" == "_--timeout_" (
  if "_%~2_" == "__" (
    echo error: value in seconds expected after --timeout
    goto error
  )
  set "timeout=%~2"
  shift
  shift
  goto options
)

if "_%~1_" == "_--no-check_" (
  set "check="
  shift
  goto options
)

if "_%~1_" == "_--_" shift

if not "_%~1_" == "__" (
  set "idir=%~1"
  shift
)

rem It's a lot more likely for someone to misspell an option than to want
rem an installation directory starting with '-'.
rem
if "_%idir:~0,1%_" == "_-_" (
  echo error: unknown option '%idir%'
  echo   info: run '%prog% -h' for usage
  goto error
)

if not "_%~1_" == "__" (
  echo error: unexpected argument '%~1'
  echo   info: options must come before the ^<install-dir^> argument
  goto error
)

rem If --no-bpkg is specified, then we require --local to also be specified
rem since it won't be possible to build things from packages without bpkg.
rem Also imply --no-bdep in this case, since bdep is pretty much useless
rem without bpkg.
rem
if "_%bpkg_install%_" == "__" (
  if "_%local%_" == "__" (
    echo error: --no-bpkg can only be used for local installation
    echo   info: additionally specify --local
    goto error
  )

  set "bdep_install="
)

for %%m in (%modules%) do (
  if "_!%%m_ver!_" == "__" (
    echo error: unknown standard build system module '%%m'
    echo   info: available standard modules: %standard_modules%
    goto error
  )
)

rem This can be a relative path so split and reconstruct. Note that if idir
rem is empty, then this is a noop (but don't try to put it inside if).
rem
for /F "delims=|" %%D in ("%idir%") do set "iname=%%~nxD"
for /F "delims=|" %%D in ("%idir%") do set "ipath=%%~dpD"
set "idir=%ipath%%iname%"

rem Get Windows version. The output of ver since XP is in this form:
rem
rem "Microsoft Windows [Version 10.0.12345]"
rem
rem While for XP it is:
rem
rem "Microsoft Windows XP [Version 5.1.12345]"
rem
rem So we make X and P delimiter to handle this.
rem
for /f "tokens=4-5 delims=.XP " %%i in ('ver') do set "r=%%i.%%j"
for /f "tokens=1 delims=." %%i in ("%r%") do set "winver=%%i"
if "%r%" == "6.3" set winver=8
if "%r%" == "6.2" set winver=8
if "%r%" == "6.1" set winver=7
set "winver_full=%r%"

rem Suppress loading of default options files.
rem
set "BUILD2_DEF_OPT=0"
set "BPKG_DEF_OPT=0"
set "BDEP_DEF_OPT=0"

if "_%mode%_" == "_uninstall_" goto uninstall
if "_%mode%_" == "_upgrade_" goto upgrade

rem The install mode.
rem
:install

rem Note that the following checks are not required for the upgrade mode due
rem to hermetic configuration.
rem

rem Get the compiler signature string. For example:
rem
rem "Microsoft (R) C/C++ Optimizing Compiler Version 19.10.24629 for x64"
rem
for /F "tokens=*" %%i in ('cl.exe 2^>^&1 ^| findstr "C/C++"') do set "sign=%%i"

if "_%sign%_" == "__" (
  echo.
  echo error: cl.exe is not found
  echo   info: re-run from the Visual Studio x64 command prompt
  goto error
)

rem Extract target architecture. The string can be translated so we cannot
rem assume x64 is the last token.
rem
rem The hack here is to "translate" the string into a sequence of quoted
rem words which can then be iterated over with plain for-loop.
rem
set arch=
for %%i in ("%sign: =" "%") do if %%i == "x64" set arch=x64

if not "_%arch%_" == "_x64_" (
  echo.
  echo error: cl.exe is not targeting 64-bit code
  echo   info: re-run from the Visual Studio x64 command prompt
  goto error
)

if "_%idir%_" == "__" (
  set "ipath=C:\"
  set "iname=build2"
  set "idir=!ipath!!iname!"
)

if not "_%trust%_" == "__" set "trust=--trust %trust%"

rem While we don't use the staged executables directly, we still want to fail
rem early if they clash with anything.
rem
call :set_exe_names %local%
if errorlevel 1 goto error

rem Omit script version check if we can't download things automatically.
rem
if %winver% LSS 8 set "check="

rem Check if the script is out of date.
rem
@echo on
@call :check_script
@if errorlevel 1 goto error
@echo off

rem If --jobs|-j is unspecified, then set it to the number of available
rem hardware threads.
rem
if "_%jobs%_" == "__" set "jobs=%NUMBER_OF_PROCESSORS%"

rem Estimate the available cores count based on the hardware threads count.
rem Note: only used for the plan printing.
rem
set "cores="
if not "_%jobs%_" == "__" (
  if !jobs! LSS 4 (
    set "cores=!jobs!"
  ) else (
    set /A "cores=!jobs! / 2"
  )
)

rem Note that if the number of jobs is unspecified and cannot be detected,
rem then we will still bootstrap in parallel and so don't need to issue any
rem warnings as we do in other build2-install-*.bat.
rem

rem Print the plan and ask for confirmation.
rem
echo.
echo -------------------------------------------------------------------------
echo.
echo About to download, build, and install build2 toolchain %ver% ^(%type%^).
echo.
echo On:    Windows %winver% ^(%winver_full%^)
echo From:  %url%
echo Using: %sign%
echo.
echo Install directory: %idir%\
echo Build directory:   %owd%\
echo.
if "_%local%_" == "__" (
echo Package repository: %repo%
echo.
)
echo For options ^(change the installation directory, etc^), run:
echo.
echo   %prog% -h
echo.
if not "_%jobs%_" == "__" (
rem Calculate the installation time as the average between the jobs and
rem cores count based installation times and round it to minutes.
rem
call :install_time %jobs%  jt
call :install_time %cores% ct
set /A "it=((!jt! + !ct!) / 2 + 30) / 60"
echo Expected installation time is approximately !it! minute^(s^).
if "_%local%_" == "__" (
echo.
echo If you are not concerned with incrementally upgrading the toolchain, you
echo may specify the --local option to reduce this time by approximately 30%%.
)
echo.
)
call :prompt_continue
if errorlevel 1 goto error

rem Show the steps we are performing.
rem
@echo on

@rem Clean up.
@rem
if exist %idir%\ rmdir /S /Q %idir%
@if errorlevel 1 goto error

@if not "_%local%_" == "__" goto rmtdir

if exist %cdir%\ rmdir /S /Q %cdir%
@if errorlevel 1 goto error

:rmtdir
if exist %tdir%\ rmdir /S /Q %tdir%
@if errorlevel 1 goto error

@rem Download baseutils.
@rem
:download_utils
@if exist %utils%.zip goto download_utils_done

@rem The automatic download is only available in PowerShell 3/Windows 8. We
@rem also fallback to manual download if automatic did not work out.
@rem
@if %winver% LSS 8 goto download_utils_manual
@call :download %url%/%ver%/%utils%.zip %utils%.zip
@if not errorlevel 1 goto download_utils_done
@echo.
@echo info: automatic download failed, falling back to manual...
:download_utils_manual
@echo.
@echo Download ^(for example, using Internet Explorer^) %utils%.zip from:
@echo.
@echo   %url%/%ver%/%utils%.zip
@echo.
@echo And place it into:
@echo.
@echo   %owd%\
@echo.
@pause
@goto download_utils
:download_utils_done

@rem Verify baseutils checksum.
@rem
@call :checksum %utils%.zip r
@if errorlevel 1 goto error
@if not "_%r%_" == "_%utils_sum%_" (
  echo.
  echo error: %utils%.zip checksum mismatch
  echo   info: calculated %r%
  echo   info: expected   %utils_sum%
  echo   info: delete %utils%.zip to force re-download
  goto error
) else (
  echo.
  echo info: %utils%.zip checksum verified successfully
  echo.
)

@rem Extract baseutils.
@rem
@rem Windows Explorer "Extract All" action will double the directory so
@rem we handle both cases.
@rem
:extract_utils
@if exist %utils%\bin\         goto extract_utils_done
@if exist %utils%\%utils%\bin\ goto extract_utils_done

@rem The automatic extraction is only available in PowerShell 3/Windows 8. We
@rem also fallback to manual extraction if automatic did not work out.
@rem
@if %winver% LSS 8 goto extract_utils_manual
powershell.exe -nologo -noprofile -command "& { try{Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%utils%.zip', '.')} catch {Write-Host $_.Exception.Message; Exit 1} }"
@if not errorlevel 1 goto extract_utils_done
@echo.
@echo info: automatic extraction failed, falling back to manual...
:extract_utils_manual
@echo.
@echo Extract ^(for example, using Windows Explorer^):
@echo.
@echo   %owd%\%utils%.zip
@echo.
@echo As:
@echo.
@echo   %owd%\%utils%
@echo.
@pause
@goto extract_utils
:extract_utils_done

@rem Move baseutils to the installation directory.
@rem
if not exist %ipath% md %ipath%
@if errorlevel 1 goto error

@if exist %utils%\%utils%\ (
  set "d=%utils%\%utils%"
) else (
  set "d=%utils%"
)

@rem If move fails (happens on some machines for no apparent reason), fall
@rem back to copying.
@rem
move %d% %idir%
@if errorlevel 1 goto try_copy

@if exist %utils%\ rmdir /S /Q %utils%
@goto skip_copy

:try_copy
@echo.
@echo info: move failed, falling back to copy...
@echo.

if not exist %idir%\ md %idir%
@if errorlevel 1 goto error

xcopy /E /Q %d%\* %idir%\
@if errorlevel 1 goto error
:skip_copy

@set "PATH=%idir%\bin;%PATH%"

@rem Download toolchain.
@rem
@rem --progress-bar | -sS
@rem
@if exist %toolchain%.tar.xz goto skip_toolchain_dl
where curl
curl -fLO --progress-bar --connect-timeout %connect_timeout%^
 --max-time %timeout% "%url%/%ver%/%toolchain%.tar.xz"
@if errorlevel 1 goto error
:skip_toolchain_dl

@rem Verify toolchain checksum.
@rem
where sha256sum
@for /F "tokens=1" %%i in ('@sha256sum -b %toolchain%.tar.xz') do @set "r=%%i"
@if not "_%r%_" == "_%toolchain_sum%_" (
  echo.
  echo error: %toolchain%.tar.xz checksum mismatch
  echo   info: calculated %r%
  echo   info: expected   %toolchain_sum%
  echo   info: delete %toolchain%.tar.xz to force re-download
  goto error
) else (
  echo.
  echo info: %toolchain%.tar.xz checksum verified successfully
  echo.
)

@rem Extract toolchain.
@rem
where xz
xz -dk %toolchain%.tar.xz
@if errorlevel 1 goto error

where tar
tar -xf %toolchain%.tar
@if errorlevel 1 goto error

del %toolchain%.tar
@if errorlevel 1 goto error

@rem Build and install.
@rem
cd %tdir%

@set "uninst_ops=--uninstall"

@if not "_%local%_" == "__" (
  set "ops=--local"
  set "uninst_ops=%uninst_ops% --local"
) else (
  set "ops=--stage-suffix %stage_suffix% --timeout %timeout% %trust%"
  set "upgrade_ops=--upgrade"
)

@if not "_%exe_prefix%_" == "__" (
  set "ops=%ops% --exe-prefix %exe_prefix%"
)

@if not "_%exe_suffix%_" == "__" (
  set "ops=%ops% --exe-suffix %exe_suffix%"
)

@if "_%bpkg_install%_" == "__" (
  set "ops=%ops% --no-bpkg"
  set "upgrade_ops=%upgrade_ops% --no-bpkg"
  set "uninst_ops=%uninst_ops% --no-bpkg"
)

@if "_%bdep_install%_" == "__" (
  set "ops=%ops% --no-bdep"
  set "upgrade_ops=%upgrade_ops% --no-bdep"
  set "uninst_ops=%uninst_ops% --no-bdep"
)

@if not "_%modules%_" == "_%standard_modules%_" (
  if "_%modules%_" == "__" (
    set "ops=%ops% --no-modules"
    set "upgrade_ops=%upgrade_ops% --no-modules"
    set "uninst_ops=%uninst_ops% --no-modules"
  ) else (
    set "ops=%ops% --modules "%modules%""
    set "upgrade_ops=%upgrade_ops% --modules "%modules%""
    set "uninst_ops=%uninst_ops% --modules "%modules%""
  )
)

@if not "_%jobs%_" == "__" set "ops=%ops% -j %jobs%"

@rem Note: executing in a separate cmd.exe to preserve the echo mode.
@rem
cmd /C .\build-msvc.bat %ops% --install-dir %idir%
@if errorlevel 1 goto error

cd ..

@if not "_%local%_" == "__" goto endinstall

rmdir /S /Q %tdir%
@if errorlevel 1 goto error

:endinstall
@echo off

rem Print the report.
rem
echo.
echo -------------------------------------------------------------------------
echo.
echo Successfully installed build2 toolchain %ver% ^(%type%^).
echo.
echo Install directory:   %idir%\
if "_%local%_" == "__" (
echo Build configuration: %cdir%\
) else (
echo Build configuration: %tdir%\
)
if "_%local%_" == "__" (
echo.
echo To upgrade, change to %owd%\ and run:
echo.
echo   %prog% %upgrade_ops%
)
echo.
echo To uninstall, change to %owd%\ and run:
echo.
echo   %prog% %uninst_ops%
echo.
echo Consider adding %idir%\bin to the PATH environment variable:
echo.
echo   set "PATH=%%PATH%%;%idir%\bin"
echo.
goto end


rem The upgrade mode.
rem
:upgrade

@echo error: no upgrade is possible for this release, perform the from-scratch installation
@goto error

if not "_%local%_" == "__" (
  echo error: upgrade is not supported for local install
  goto error
)

rem Check if the script is out of date.
rem
@echo on
@call :check_script
@if errorlevel 1 goto error
@echo off

rem First check if we already have the current version (i.e., patch upgrade).
rem Then previous version, unless empty (no upgrade possible).
rem
rem If this is a patch release, then we do the "dirty" upgrade. Otherwise --
rem staged.
rem
set "kind="
if exist %cdir%\ (
  set "kind=dirty"
  set "ucdir=%cdir%"
  set "ionly=true"
) else (
  if exist %pcdir%\ (
    if not "_%pcver%_" == "__" (
      set "kind=staged"
      set "ucdir=%pcdir%"
      set "ionly="
    ) else (
      echo.
      echo error: no upgrade is possible, perform the from-scratch installation
      goto error
    )
  )
)

if "_%kind%_" == "__" (
  echo.
  echo error: no existing build configuration in %cdir%\ or %pcdir%\
  goto error
)

call :set_install_root %ucdir%
if errorlevel 1 goto error

call :set_exe_affix prefix %ucdir%
if errorlevel 1 goto error

call :set_exe_affix suffix %ucdir%
if errorlevel 1 goto error

call :set_exe_names %ionly%
if errorlevel 1 goto error

rem Print the plan and ask for confirmation. For now we don't support
rem upgrading baseutils so warn unless this is a patch release upgrade.
rem
echo.
echo -------------------------------------------------------------------------
echo.
echo About to perform %kind% upgrade of build2 toolchain to %ver% ^(%type%^).
if not "_%kind%_" == "_dirty_" (
echo.
echo WARNING: baseutils will NOT be upgraded, perform the from-scratch^
 installation to upgrade this package.
)
echo.
echo Install directory:   %idir%\
echo Build configuration: %ucdir%\
if not exist %idir%\bin\%b%.exe (
echo.
echo WARNING: %idir%\ does not seem to contain a build2 installation.
)
echo.
echo Package repository: %repo%
echo.
call :prompt_continue
if errorlevel 1 goto error

rem Add %idir%\bin to PATH in case it is not already there.
rem
set "PATH=%idir%\bin;%PATH%"

rem Translate our options to their bpkg versions, same as in build-msvc.bat
rem from build2-toolchain.
rem
if not "_%jobs%_" == "__" set "jobs=-j %jobs%"

if not "_%trust%_" == "__" (
          if "_%trust%_" == "_yes_" (set "trust=--trust-yes"
  ) else (if "_%trust%_" == "_no_"  (set "trust=--trust-no"
  ) else                            (set "trust=--trust %trust%"))
)

if not "_%timeout%_" == "__" (
  set "timeout=--fetch-timeout %timeout%"
)

rem Note that we use bpkg-rep-fetch(1) to both add and only fetch this
rem repository if it's not the same as the existing.

rem Show the steps we are performing.
rem
@echo on

@set "packages=build2/%build2_ver% bpkg/%bpkg_ver%"

@if "_%bdep_install%_" == "_true_" (
  set "packages=%packages% bdep/%bdep_ver%"
)

@for %%m in (%modules%) do @set "packages=!packages! libbuild2-%%m/!%%m_ver!"

@if not "_%kind%_" == "_dirty_" goto upgrade_staged

cd %cdir%

where %bpkg%
%bpkg% %timeout% %trust% fetch %repo%
@if errorlevel 1 goto error

%bpkg% %jobs% %timeout% build --for install --patch --recursive --yes --plan= %packages%
@if errorlevel 1 goto error

%bpkg% %jobs% install --all
@if errorlevel 1 goto error

cd /D %owd%

@goto upgrade_done
:upgrade_staged

md %cdir%
@if errorlevel 1 goto error

xcopy /E /Q %ucdir%\* %cdir%\
@if errorlevel 1 goto error

cd %cdir%

where %bpkg%
%bpkg% %timeout% %trust% fetch %repo%
@if errorlevel 1 goto error

%bpkg% %jobs% %timeout% build --for install --upgrade --recursive --yes --plan= %packages%
@if errorlevel 1 goto error

@rem Note: not installing bdep-stage since we don't need it.
@rem
@set "stage_conf=config.bin.suffix=%stage_suffix%"
@set "stage_conf=%stage_conf% config.bin.exe.prefix=[null] config.bin.exe.suffix=[null]"
@set "stage_conf=%stage_conf% config.install.data_root=root\stage"

%bpkg% %jobs% install %stage_conf% build2 bpkg
@if errorlevel 1 goto error

where %b_stage%
@if errorlevel 1 goto error

%b_stage% --version
@if errorlevel 1 goto error

where %bpkg_stage%
@if errorlevel 1 goto error

%bpkg_stage% --version
@if errorlevel 1 goto error

cd /D %owd%
cd %ucdir%

%bpkg% %jobs% uninstall --all
@if errorlevel 1 goto error

cd /D %owd%
cd %cdir%

%bpkg_stage% %jobs% install --all
@if errorlevel 1 goto error

%bpkg% %jobs% uninstall %stage_conf% build2 bpkg
@if errorlevel 1 goto error

cd /D %owd%

:upgrade_done

%b% --version
@if errorlevel 1 goto error

%bpkg% --version
@if errorlevel 1 goto error

@if "_%bdep_install%_" == "__" goto bve

%bdep% --version
@if errorlevel 1 goto error

:bve

@echo off

rem Print the report. The new configuration is always in cdir.
rem
echo.
echo -------------------------------------------------------------------------
echo.
echo Successfully upgraded build2 toolchain to %ver% ^(%type%^).
echo.
echo Install directory:   %idir%\
echo Build configuration: %cdir%\
if not "_%ucdir%_" == "_%cdir%_" (
echo.
echo Old configuration:   %ucdir%\
)
echo.
goto end


rem The uninstall mode.
rem
:uninstall

if "_%local%_" == "__" (
  set "ucdir=%cdir%"
) else (
  set "ucdir=%tdir%"
)

call :set_install_root %ucdir%
if errorlevel 1 goto error

rem Print the plan and ask for confirmation.
rem
echo.
echo -------------------------------------------------------------------------
echo.
echo About to uninstall build2 toolchain %ver% ^(%type%^).
echo.
echo Install directory:   %idir%\
echo Build configuration: %ucdir%\
echo.
call :prompt_continue
if errorlevel 1 goto error

rem Show the steps we are performing.
rem
@echo on

@rem While we could have run bpkg-uninstall, we would still need to remove
@rem the directory because of baseutils. So let's keep it simple.
@rem
rmdir /S /Q %idir%

@if "_%local%_" == "__" (
  goto uninstallcdir
) else (
  goto uninstalltdir
)

: uninstallcdir
rmdir /S /Q %cdir%
@goto enduninstall

: uninstalltdir
rmdir /S /Q %tdir%
@goto enduninstall

:enduninstall
@echo off

rem Print the report.
rem
echo.
echo -------------------------------------------------------------------------
echo.
echo Successfully uninstalled build2 toolchain %ver% ^(%type%^).
echo.

goto end

:error
@echo off
cd /D %owd%
endlocal
exit /b 1

:end
endlocal
