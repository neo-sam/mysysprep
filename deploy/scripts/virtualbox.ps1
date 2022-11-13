#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'virtualbox-*win*.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'VirtualBox'
        target = 'C:\Program Files\Oracle\VirtualBox\VirtualBox.exe'
        mutex  = 1
    }
    return
}

Start-Process -Wait $pkg '-s -l -msiparams REBOOT=ReallySuppress'

# CUSTOM:

Push-SystemPath 'C:\Program Files\Oracle\VirtualBox'
