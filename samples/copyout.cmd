@echo off
cd /d %~dp0\..
powershell -exec bypass -file samples\copyout.ps1
