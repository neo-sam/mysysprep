@echo off
if not "%1"=="elevated" (powershell start -verb runas '%0' elevated & exit /b)
cd %~dp0\scripts
powershell -exec bypass -file setup-devenv.ps1
echo.
echo FINISHED ALL!
echo.
pause
