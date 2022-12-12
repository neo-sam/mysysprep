@echo off
cd /d %~dp0
powershell -exec bypass -file lib\get-valid-subjects.ps1
pause
