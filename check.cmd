@echo off
cd /d %~dp0
powershell -exec bypass -file .\tools\print-config.ps1
pause
