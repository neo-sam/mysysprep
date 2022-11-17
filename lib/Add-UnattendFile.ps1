#Requires -RunAsAdministrator

if ($null -eq (Get-Content '.\lib\assets\unattend.xml' -ea 0)) { exit }

.\lib\Write-UnattendFile.ps1 | Out-File -Force -Encoding utf8 C:\Windows\Panther\unattend.xml
