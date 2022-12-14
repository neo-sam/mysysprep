#Requires -RunAsAdministrator

if (!(Get-Item -ea 0 '.minttyrc')) { exit }

& ./codegen.ps1 | Out-FileUtf8NoBom "$(mkdir -f 'C:\Program Files\Git\etc')\minttyrc"
