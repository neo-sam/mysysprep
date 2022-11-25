#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'virtualbox-*win*.exe'
$appdir = 'C:\Program Files\Oracle\VirtualBox'

if ($GetMetadata) {
    return @{
        name   = 'VirtualBox'
        match  = $match
        mutex  = $true
        ignore = { Test-Path "$appdir\VirtualBox.exe" }
    }
}

Start-Process -Wait $match '-s -l -msiparams REBOOT=ReallySuppress'

# CUSTOM:

if (!(Test-Path $appdir)) { throw 'Installed Failed' }

Add-SystemPath $appdir
