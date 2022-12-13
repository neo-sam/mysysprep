#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-Item -ea 0 'Thunderbird Setup *.exe'

if ($GetMetadata) {
    return @{
        name   = 'Thunderbird'
        match  = $match
        ignore = Get-BooleanReturnFn (Test-Path 'C:\Program Files\Mozilla Thunderbird\thunderbird.exe')
    }
}

Start-ProcessToInstall $match '/S /DesktopShortcut=false'
