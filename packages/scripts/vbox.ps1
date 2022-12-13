#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-Item -ea 0 'virtualbox-*win*.exe'
$appdir = 'C:\Program Files\Oracle\VirtualBox'

if ($GetMetadata) {
    return @{
        name   = 'VirtualBox'
        match  = $match
        mutex  = $true
        ignore = Get-BooleanReturnFn (Test-Path "$appdir\VirtualBox.exe")
    }
}

Start-ProcessToInstall $match '-s -l -msiparams REBOOT=ReallySuppress'
if (!(Test-Path $appdir)) { throw 'Installed Failed' }

# CUSTOM:

Add-SystemPath $appdir

Move-DesktopIconFromPublicToDefaultAndCurrentUserIfAuditMode 'Oracle VM VirtualBox'
