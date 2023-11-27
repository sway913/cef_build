@echo off
cd /d %~dp0

echo "-----------start----------"

set DEPOT_TOOLS_DIR=%~dp0..\depot_tools
set AUTOMATE_GIT_PATH=%~dp0..\automate\automate-git.py
set DOWNLOAD_DIR=%~dp0..\chromium_git

if not exist %DOWNLOAD_DIR% mkdir %DOWNLOAD_DIR%


set CEF_USE_GN=1
set GN_DEFINES=is_official_build=true
set GYP_DEFINES=buildtype=Official
set GYP_MSVS_VERSION=2019
set CEF_ARCHIVE_FORMAT=tar.bz2
set GN_ARGUMENTS=--ide=vs2019 --sln=cef --filters=//cef/*


python %AUTOMATE_GIT_PATH% --download-dir=%DOWNLOAD_DIR% --depot-tools-dir=%DEPOT_TOOLS_DIR% --branch=5414 --no-build --no-distrib --no-depot-tools-update --force-clean 

echo "-----------all finish----------"

pause