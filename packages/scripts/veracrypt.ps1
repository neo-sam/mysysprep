#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-Item -ea 0 'VeraCrypt_Setup_x64_*.msi'
if ($GetMetadata) {
    return @{
        name   = 'VeraCrypt'
        match  = $match
        mutex  = $true
        ignore = Get-BooleanReturnFn (Test-Path 'C:\Program Files\VeraCrypt\VeraCrypt.exe')
    }
}

Start-ProcessToInstall $match '/qb /norestart /l*v logs\veracrypt.log ACCEPTLICENSE=YES'

# CUSTOM:

Move-DesktopIconFromPublicToDefaultAndCurrentUserIfAuditMode 'VeraCrypt'
