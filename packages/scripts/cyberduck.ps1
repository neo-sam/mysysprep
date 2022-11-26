#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'Cyberduck-Installer-*.exe'
$appbin = 'C:\Program Files\Cyberduck\Cyberduck.exe'

if ($GetMetadata) {
    return @{
        name   = 'Cyberduck'
        match  = $match
        ignore = Get-BooleanReturnFn (Test-Path $appbin)
    }
}

Start-Process -Wait $match /quiet

# CUSTOM:

Repair-HidpiCompatibility $appbin
