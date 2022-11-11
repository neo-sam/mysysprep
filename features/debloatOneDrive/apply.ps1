#Requires -RunAsAdministrator
# reference: https://github.com/W4RH4WK/Debloat-Windows-10

Stop-Process -Name OneDrive -ea 0

if (Test-Path "$env:LOCALAPPDATA\Microsoft\OneDrive\OneDrive.exe") {
    if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") {
        & "$env:systemroot\System32\OneDriveSetup.exe" /uninstall
    }
    if (Test-Path "$env:systemroot\SysWOW64\OneDriveSetup.exe") {
        & "$env:systemroot\SysWOW64\OneDriveSetup.exe" /uninstall
    }
}

$ErrorActionPreference = 'SilentlyContinue'

Wait-Process OneDriveSetup

Remove-Item -Recurse -Force "$env:localappdata\Microsoft\OneDrive"
Remove-Item -Recurse -Force "$env:programdata\Microsoft OneDrive"
Remove-Item -Recurse -Force "$env:systemdrive\OneDriveTemp"

# check if directory is empty before removing:
if ((Get-ChildItem "$env:userprofile\OneDrive" -Recurse | Measure-Object).Count -eq 0) {
    Remove-Item -Recurse -Force "$env:userprofile\OneDrive"
}

$ErrorActionPreference = 'Continue'

# Disable OneDrive via Group Policies
Set-ItemProperty (
    mkdir -f "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive"
).PSPath "DisableFileSyncNGSC" 1

# Removing run hook for new users
Remove-ItemProperty (
    Get-CurrentAndNewUserPaths "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup"
) OneDriveSetup -ea 0

$ErrorActionPreference = 'SilentlyContinue'

Remove-Item -Force "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"
Get-ScheduledTask -TaskName 'OneDrive*' | Unregister-ScheduledTask -Confirm:$false
