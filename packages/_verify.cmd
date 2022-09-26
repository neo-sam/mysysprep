@echo off
cd "%~dp0"
powershell -exec bypass -file _verify.ps1
pause