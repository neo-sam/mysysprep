@echo off
if not "%1"=="elevated" (powershell start -verb runas '%0' elevated & exit /b)
cd /d %~dp0\..
powershell -exec bypass -file modules\deploy-pkgs\main.ps1
pause
