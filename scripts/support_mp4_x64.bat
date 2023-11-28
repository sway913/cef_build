@echo off
cd /d %~dp0

echo "-----------start----------"

REM set your path
set DOWNLOAD_DIR=%~dp0..\chromium_git
set update_mp4_config=%~dp0mp4_support_config.txt
set update_mp4_py=%~dp0update_mp4.py
set backup_dir=%~dp0backup\x64

REM backup config.h
REM backup config.h
if not exist %backup_dir% (
	mkdir %backup_dir%
	xcopy "%DOWNLOAD_DIR%\chromium\src\third_party\ffmpeg\chromium\config\Chrome\win\x64\config.h" "%backup_dir%" /y
	echo "-----------backup done----------"
)

python %update_mp4_py% %update_mp4_config% %DOWNLOAD_DIR%/chromium/src/third_party/ffmpeg/chromium/config/Chrome/win/x64/config.h

echo "-----------all finish----------"

pause