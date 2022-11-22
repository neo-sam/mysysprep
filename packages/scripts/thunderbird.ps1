#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'Thunderbird Setup *.exe'

if ($GetMetadata) {
    return @{
        name   = 'Thunderbird'
        match  = $match
        ignore = { Test-Path 'C:\Program Files\Mozilla Thunderbird\thunderbird.exe' }
    }
}

Start-Process -Wait $match '/S /DesktopShortcut=false'
