#Requires -RunAsAdministrator

Push-Location C:\Windows\System32
Get-ChildItem mmc.exe, perfmon.exe | Repair-HidpiCompatibility
Pop-Location
