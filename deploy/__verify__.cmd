@echo off
cd "%~dp0\scripts"
powershell -exec bypass -file _verify.ps1
pause
