#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'kdeconnect-kde-*-windows-*.exe'

if ($GetMetadata) {
    return @{
        name   = 'KDE Connect'
        match  = $match
        ignore = Get-BooleanReturnFn (Test-Path 'C:\Program Files\KDE Connect\bin\kdeconnect-app.exe')
    }
}

Start-Process -Wait $match /S
