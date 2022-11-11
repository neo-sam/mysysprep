#Requires -RunAsAdministrator

# Skip first screen
Set-ItemProperty (
    mkdir -f HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge
).PSPath PreventFirstRunPage 0
Set-ItemProperty (
    mkdir -f HKLM:\SOFTWARE\Policies\Microsoft\WindowsMediaPlayer
).PSPath GroupPrivacyAcceptance 1

# Disable hiberboot for SSD
if (Get-Command -ea 0 Get-PhysicalDisk) {
    if ('SSD' -eq (Get-PhysicalDisk)[0].MediaType) {
        Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' HiberbootEnabled 0
    }
}

# No crash report or capbility check
Disable-BundledService PcaSvc, WerSvc

# Windows10 only: colorize window title
if ([Environment]::OSVersion.Version.Build -le 22000) {
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths "HKCU:\SOFTWARE\Microsoft\Windows\DWM"
    ) ColorPrevalence 1
}
