@echo off
cd /d %~dp0\..
powershell -exec bypass -file samples\__applyall__.ps1
