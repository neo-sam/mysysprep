@echo off
net session >nul 2>&1
if not %errorLevel% == 0 if not "%1"=="elevated" (
powershell start -verb runas '%0' elevated & exit /b
)
cd /d %~dp0
title win-sf
powershell -exec bypass -file setup.ps1
