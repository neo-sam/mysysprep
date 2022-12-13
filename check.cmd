@echo off
cd /d %~dp0
powershell -exec bypass -file tools\lib\print-config.ps1
pause
