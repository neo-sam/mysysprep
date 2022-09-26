@echo off
if not "%1"=="elevated" (powershell start -verb runas '%0' elevated & exit /b)
cd "%~dp0"
powershell -exec bypass -file scripts\setup.ps1
powershell -exec bypass -file scripts\setup-devenv.ps1
echo.
echo FINISHED ALL!
echo.
pause
