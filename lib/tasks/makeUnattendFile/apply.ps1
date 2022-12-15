#Requires -RunAsAdministrator

& "$PSScriptRoot\generator.ps1" | Out-File -Force -Encoding utf8 C:\Windows\Panther\unattend.xml
