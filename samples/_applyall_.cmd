@echo off
cd /d %~dp0\..
powershell -exec bypass -file samples\_applyall_.ps1
