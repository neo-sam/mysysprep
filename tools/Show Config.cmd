@echo off
cd /d %~dp0
powershell -exec bypass -file lib\print-config.ps1
echo.
pause
