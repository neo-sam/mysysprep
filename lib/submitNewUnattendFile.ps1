#Requires -RunAsAdministrator
. .\lib\loadModules.ps1

New-UnattendFile | Out-File -Force -Encoding utf8 C:\Windows\Panther\unattend.xml
