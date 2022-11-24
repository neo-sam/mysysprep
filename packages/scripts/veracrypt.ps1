#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'VeraCrypt_Setup_x64_*.msi'
if ($GetMetadata) {
    return @{
        name   = 'VeraCrypt'
        match  = $match
        mutex  = $true
        target = 'C:\Program Files\VeraCrypt\VeraCrypt.exe'
    }
}

Start-Process -Wait $match '/qb /norestart /l*v logs\veracrypt.log ACCEPTLICENSE=YES'
