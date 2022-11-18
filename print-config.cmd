@echo off
cd /d %~dp0
powershell -exec bypass -file .\tools\printConfig.ps1
pause
