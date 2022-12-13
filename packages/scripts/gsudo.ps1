#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-Item -ea 0 'gsudoSetup.msi'
$appbin = 'C:\Program Files (x86)\gsudo\gsudo.exe'

if ($GetMetadata) {
    return @{
        name   = 'gsudo'
        match  = $match
        mutex  = $true
        ignore = Get-BooleanReturnFn (Test-Path $appbin)
    }
}

Start-ProcessToInstall $match '/qb /norestart /l*v logs\gsudo.log'
