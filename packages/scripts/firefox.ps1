#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'Firefox Setup *.exe'
$appbin = 'C:\Program Files\Mozilla Firefox\firefox.exe'

if ($GetMetadata) {
    return @{
        name   = 'Firefox'
        match  = $match
        ignore = if (Test-Path $appbin) { { 1 } }else { { 0 } }
    }
}

Start-Process -Wait $match '/S /DesktopShortcut=false'
