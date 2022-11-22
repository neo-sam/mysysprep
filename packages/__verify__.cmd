@echo off
cd /d %~dp0
powershell -exec bypass -file scripts\verify.ps1
pause
