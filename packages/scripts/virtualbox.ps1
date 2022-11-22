#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'virtualbox-*win*.exe'

if ($GetMetadata) {
    return @{
        name   = 'VirtualBox'
        match  = $match
        mutex  = $true
        ignore = { Test-Path 'C:\Program Files\Oracle\VirtualBox\VirtualBox.exe' }
    }
}

Start-Process -Wait $match '-s -l -msiparams REBOOT=ReallySuppress'

# CUSTOM:

Add-SystemPath 'C:\Program Files\Oracle\VirtualBox'
