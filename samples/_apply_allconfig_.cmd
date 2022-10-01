@echo off
cd /d %~dp0\..
powershell -exec bypass -file samples\_apply_allconfig_.ps1
