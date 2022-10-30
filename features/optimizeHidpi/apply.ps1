#Requires -RunAsAdministrator

Push-Location C:\Windows\System32
Get-ChildItem mmc.exe, perfmon.exe | Set-HidpiMode
Pop-Location
