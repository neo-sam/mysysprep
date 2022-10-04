@echo off
net session >nul 2>&1
if not %errorLevel% == 0 if not "%1"=="elevated" (
powershell start -verb runas '%0' elevated & exit /b
)
for %%I in (.) do set name=%%~nxI
cd /d %~dp0\..\..
title module[%name%]
powershell -exec bypass -file modules\%name%\main.ps1
pause
