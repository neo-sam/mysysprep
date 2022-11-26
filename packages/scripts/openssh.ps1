#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'OpenSSH-Win64-v*.msi'

if ($GetMetadata) {
    return @{
        name   = 'Upgraded OpenSSH'
        match  = $match
        mutex  = $true
        ignore = Get-BooleanReturnFn (Test-Path 'C:\Program Files\OpenSSH\sshd.exe')
    }
}

Start-Process -Wait $match '/qb /norestart',
'/l*v logs\openssh.log'

# CUSTOM:

Stop-Service sshd
Set-Service sshd -StartupType Disabled
