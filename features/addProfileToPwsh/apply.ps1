#Requires -RunAsAdministrator

if (!(Test-Path ($target = 'C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1'))) {
    Copy-Item .\profile.ps1 $target
}
