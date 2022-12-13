#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-Item -ea 0 'Cyberduck-Installer-*.exe'
$appbin = 'C:\Program Files\Cyberduck\Cyberduck.exe'

if ($GetMetadata) {
    return @{
        name   = 'Cyberduck'
        match  = $match
        ignore = Get-BooleanReturnFn (Test-Path $appbin)
    }
}

Start-ProcessToInstall $match /quiet

# CUSTOM:

Repair-HidpiCompatibility $appbin
