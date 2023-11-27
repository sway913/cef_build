@echo off
cd /d %~dp0

echo "-----------start----------"

set DEPOT_TOOLS_DIR=%~dp0..\depot_tools
set AUTOMATE_GIT_PATH=%~dp0..\automate\automate-git.py

@if not exist %DEPOT_TOOLS_DIR% (
    echo "Downloading depot_tools from CEF repository"
	git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git %DEPOT_TOOLS_DIR%
)

@if not exist %AUTOMATE_GIT_PATH% (
    echo "Downloading automate-git.py script from CEF repository"
	mkdir %~dp0..\automate
	curl -o %AUTOMATE_GIT_PATH% https://bitbucket.org/chromiumembedded/cef/raw/master/tools/automate/automate-git.py
)

@if exist %DEPOT_TOOLS_DIR% (
    echo "update depot_tools from CEF repository"
	call "%DEPOT_TOOLS_DIR%\update_depot_tools.bat"
)

echo "-----------all finish----------"

pause