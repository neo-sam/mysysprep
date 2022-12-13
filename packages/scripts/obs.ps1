#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-Item -ea 0 'OBS-Studio-*-Full-Installer-x64.exe'

if ($GetMetadata) {
    return @{
        name   = 'OBS'
        match  = $match
        ignore = Get-BooleanReturnFn (Test-Path 'C:\Program Files\obs-studio\bin\64bit\obs64.exe')
    }
}

Start-ProcessToInstall $match '/NCRC /S'

# CUSTOM:

Remove-Item 'C:\Users\public\Desktop\OBS Studio.lnk'
