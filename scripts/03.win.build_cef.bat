@echo off
cd /d %~dp0

echo "-----------start----------"

REM set your source download dir
set DEPOT_TOOLS_DIR=%~dp0..\depot_tools
set AUTOMATE_GIT_PATH=%~dp0..\automate\automate-git.py
set DOWNLOAD_DIR=%~dp0..\chromium_git

REM set py utf-8
set PYTHONLEGACYWINDOWSSTDIO=utf8
set PYTHONIOENCODING=utf8
set PYTHONUTF8=1
REM set gn
set CEF_USE_GN=1


REM build ffmpeg
REM set GN_DEFINES=is_official_build=true proprietary_codecs=true ffmpeg_branding=Chrome
REM if not set chrome_pgo_phase=0 will error(RuntimeError: requested profile  pgo_profiles\chrome-win64-5414)
set GN_DEFINES=is_official_build=true chrome_pgo_phase=0
set GN_ARGUMENTS=--ide=vs2019 --sln=cef --filters=//cef/*

set GYP_DEFINES=buildtype=Official
set GYP_MSVS_VERSION=2019
set CEF_ARCHIVE_FORMAT=tar.bz2
set GYP_GENERATORS=ninja,msvs-ninja

REM set your version
set vc_redist_version=14.29.30133
set vc_tools_version=14.29.30133
set sdk_version=10.0.20348.0
set arch=x86

REM set your vs install path env
set vs_root=C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional
set vs_crt_root=%vs_root%\VC\Tools\MSVC\%vc_tools_version%\crt\src\vcruntime

set WIN_CUSTOM_TOOLCHAIN=1
set CEF_VCVARS=none
set GYP_MSVS_OVERRIDE_PATH=%vs_root%
set VS_CRT_ROOT=%vs_crt_root%
set SDK_ROOT=%sdk_root%
set PATH=%sdk_root%\bin\%sdk_version%\x64;%vs_root%\VC\Tools\MSVC\%vc_tools_version%\bin\HostX64\x64;%vs_root%\VC\Redist\MSVC\%vc_redist_version%\x64\%vc_redist_crt%;%vs_root%\SystemCRT;%PATH%
set LIB=%sdk_root%\Lib\%sdk_version\um\%arch%;%sdk_root%\Lib\%sdk_version\ucrt\%arch%;%vs_root%\VC\Tools\MSVC\%vc_tools_version%\lib\%arch%;%vs_root%\VC\Tools\MSVC\%vc_tools_version%\atlmfc\lib\%arch%;%LIB%
set INCLUDE=%sdk_root%\Include\%sdk_version%\um;%sdk_root%\Include\%sdk_version%\ucrt;%sdk_root%\Include\%sdk_version%\shared;%vs_root%\VC\Tools\MSVC\%vc_tools_version%\include;%vs_root%\VC\Tools\MSVC\%vc_tools_version%\atlmfc\include;%INCLUDE%

REM build start
python %AUTOMATE_GIT_PATH% --download-dir=%DOWNLOAD_DIR% --depot-tools-dir=%DEPOT_TOOLS_DIR% --branch=5414 --build-log-file --verbose-build --force-distrib --force-build --no-debug-build --no-update

echo "-----------all finish----------"

pause