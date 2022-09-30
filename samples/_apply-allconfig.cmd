@echo off
cd /d %~dp0\..
powershell -exec bypass -file samples\_apply-allconfig.ps1
