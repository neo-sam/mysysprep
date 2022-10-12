@echo off
cd "%~dp0\.."
powershell -exec bypass -file .debug\clean.ps1
