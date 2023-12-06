@echo off
cd /d %~dp0

echo "-----------start----------"

set dockerfile_path=%~dp0windows.Dockerfile

docker build -t bel913/win_dev:v1.0 -f %dockerfile_path% -m 2GB .

echo "-----------all finish----------"

::after run cmd:
::docker run -it --name win_dev --mount type=bind,source=G:\cef_build,target=C:\cef_build bel913/win_dev:v1.0

pause