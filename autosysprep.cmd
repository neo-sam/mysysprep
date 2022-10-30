@echo off
net session >nul 2>&1
if not %errorLevel% == 0 if not "%1"=="elevated" (
powershell start -verb runas '%0' elevated & exit /b
)
cd /d %~dp0
title autosysprep
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /f /t REG_SZ /v "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" /d "~ HIGHDPIAWARE"
powershell -exec bypass -file autosysprep.ps1
