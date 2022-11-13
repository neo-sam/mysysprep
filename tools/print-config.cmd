@echo off
cd /d %~dp0\..
powershell -exec bypass -file .\tools\Write-Config.ps1
pause
