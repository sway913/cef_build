@echo off
cd /d %~dp0

echo "-----------start----------"

:: set your source download dir
set DEPOT_TOOLS_DIR=%~dp0..\depot_tools
set AUTOMATE_GIT_PATH=%~dp0..\automate\automate-git.py
set DOWNLOAD_DIR=%~dp0..\chromium_git

:: set py utf-8
set PYTHONLEGACYWINDOWSSTDIO=utf8
set PYTHONIOENCODING=utf8
set PYTHONUTF8=1



:: build ffmpeg flags
set GN_DEFINES=is_official_build=true chrome_pgo_phase=0 proprietary_codecs=true ffmpeg_branding=Chrome
REM set GN_DEFINES=is_official_build=true chrome_pgo_phase=0

set CEF_USE_GN=1
set GYP_DEFINES=buildtype=Official
set GN_ARGUMENTS=--ide=vs2022 --sln=cef --filters=//cef/*
set GYP_MSVS_VERSION=2022
set CEF_ARCHIVE_FORMAT=tar.bz2
set GYP_GENERATORS=ninja,msvs-ninja

set WIN_CUSTOM_TOOLCHAIN=1
set CEF_VCVARS=none

:: set your version
set vc_redist_version=14.38.33130
set vc_tools_version=14.38.33130
set sdk_version=10.0.20348.0

:: Custom build Parameters
REM set arch=x86
set arch=x64
set build_debug="1"
set only_debug="1"
set build_distrib="0"

:: config output build flags
set build_flag=

if "%arch%" equ "x64" (
	set build_flag=--x64-build
)

if %build_debug% equ "0" (
	set build_flag=%build_flag% --no-debug-build
)

if %only_debug% equ "1" (
	set build_flag=%build_flag% --no-release-build 
)

if %build_distrib% equ "1" (
	set build_flag=%build_flag% --force-distrib 
) else (
	set build_flag=%build_flag% --no-distrib 
)


echo "build_flag=%build_flag%"


:: set your vs and sdk install path
REM set vs_root=C:\Program Files\Microsoft Visual Studio\2022\Community
set vs_root=D:\Program Files\Microsoft Visual Studio\2022\Professional
set VS_CRT_ROOT=%vs_root%\VC\Tools\MSVC\%vc_tools_version%\crt\src\vcruntime
set SDK_ROOT=C:\Program Files (x86)\Windows Kits\10

set GYP_MSVS_OVERRIDE_PATH=%vs_root%

set PATH=%SDK_ROOT%\bin\%sdk_version%\x64;%vs_root%\VC\Tools\MSVC\%vc_tools_version%\bin\HostX64\x64;%vs_root%\VC\Redist\MSVC\%vc_redist_version%\x64\%vc_redist_crt%;%vs_root%\SystemCRT;%PATH%
set LIB=%SDK_ROOT%\Lib\%sdk_version%\um\%arch%;%SDK_ROOT%\Lib\%sdk_version%\ucrt\%arch%;%vs_root%\VC\Tools\MSVC\%vc_tools_version%\lib\%arch%;%vs_root%\VC\Tools\MSVC\%vc_tools_version%\atlmfc\lib\%arch%;%LIB%
set INCLUDE=%SDK_ROOT%\Include\%sdk_version%\um;%SDK_ROOT%\Include\%sdk_version%\ucrt;%SDK_ROOT%\Include\%sdk_version%\shared;%vs_root%\VC\Tools\MSVC\%vc_tools_version%\include;%vs_root%\VC\Tools\MSVC\%vc_tools_version%\atlmfc\include;%INCLUDE%

:: build start
python %AUTOMATE_GIT_PATH% --download-dir=%DOWNLOAD_DIR% --depot-tools-dir=%DEPOT_TOOLS_DIR% --branch=5414 --build-log-file --verbose-build  --force-build --no-update %build_flag%

echo "-----------all finish----------"

pause