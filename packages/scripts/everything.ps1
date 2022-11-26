#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'Everything-*.x64.Lite-Setup.exe'
$appbin = 'C:\Program Files\Everything\Everything.exe'

if ($GetMetadata) {
    return @{
        name   = 'Everything'
        match  = $match
        ignore = Get-BooleanReturnFn (Test-Path $appbin)
    }
}

Start-Process -Wait $match /S

# CUSTOM:

if (Test-Path ($it = 'config\Everything.ini')) {
    if (!(Test-Path ($that = "$env:APPDATA\Everything\Everything.ini"))) {
        Copy-Item $it $that
    }
    Copy-Item $it (mkdir -f 'C:\Users\Default\AppData\Roaming\Everything')
}

Repair-HidpiCompatibility $appbin
