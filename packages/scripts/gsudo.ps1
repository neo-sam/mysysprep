#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'gsudoSetup.msi'
$appbin = 'C:\Program Files (x86)\gsudo\gsudo.exe'

if ($GetMetadata) {
    return @{
        name   = 'gsudo'
        match  = $match
        mutex  = $true
        ignore = if (Test-Path $appbin) { { 1 } }else { { 0 } }
    }
}

Start-Process -Wait $match "/qb /norestart /l*v logs\gsudo.log"
