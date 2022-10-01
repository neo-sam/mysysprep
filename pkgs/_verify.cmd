@echo off
cd "%~dp0"
powershell -exec bypass -file ..\lib\verify.ps1
pause
