@echo off
net session >nul 2>&1
if not %errorLevel% == 0 if not "%1"=="elevated" (
powershell start -verb runas '%0' elevated & exit /b
)
cd /d %~dp0
title sysprep-go
powershell -exec bypass -file sysprep-go.ps1
