#Requires -RunAsAdministrator
# reference: https://github.com/W4RH4WK/Debloat-Windows-10

Stop-Process -Name OneDrive -ea 0

if (Test-Path "$env:LOCALAPPDATA\Microsoft\OneDrive\OneDrive.exe") {
    if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") {
        Start-Process -Wait "$env:systemroot\System32\OneDriveSetup.exe" '/uninstall'
    }
    if (Test-Path "$env:systemroot\SysWOW64\OneDriveSetup.exe") {
        Start-Process -Wait "$env:systemroot\SysWOW64\OneDriveSetup.exe" '/uninstall'
    }
}

$ErrorActionPreferenceOld = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'

Get-ScheduledTask -TaskName 'OneDrive*' | Unregister-ScheduledTask -Confirm:$false

Set-ItemProperty 'HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive' DisableFileSyncNGSC 1
Remove-ItemProperty 'HKLM:\NewUser\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' OneDriveSetup -ea 0

Remove-Item -Recurse -Force "$env:localappdata\Microsoft\OneDrive"
Remove-Item -Recurse -Force "$env:programdata\Microsoft OneDrive"
Remove-Item -Recurse -Force "$env:systemdrive\OneDriveTemp"
Remove-Item -Force "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"

if ((Get-ChildItem "$env:userprofile\OneDrive" -Recurse | Measure-Object).Count -eq 0) {
    Remove-Item -Recurse -Force "$env:userprofile\OneDrive"
}

$ErrorActionPreference = $ErrorActionPreferenceOld
