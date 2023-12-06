@echo off
cd /d %~dp0

echo "-----------start----------"

set dockerfile_path=%~dp0windows.Dockerfile

docker build -t bel913/linux_dev:v1.0 -f %dockerfile_path% .

echo "-----------all finish----------"

pause