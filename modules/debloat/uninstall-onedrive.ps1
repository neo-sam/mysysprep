# reference: https://github.com/W4RH4WK/Debloat-Windows-10

. .\lib\require-admin.ps1

Write-Output "Kill OneDrive process"

taskkill.exe /F /IM "OneDrive.exe"
# taskkill.exe /F /IM "explorer.exe"

if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") {
    & "$env:systemroot\System32\OneDriveSetup.exe" /uninstall
}
if (Test-Path "$env:systemroot\SysWOW64\OneDriveSetup.exe") {
    & "$env:systemroot\SysWOW64\OneDriveSetup.exe" /uninstall
}

$ErrorActionPreference = 'SilentlyContinue'

Wait-Process OneDriveSetup

Remove-Item -Recurse -Force "$env:localappdata\Microsoft\OneDrive"
Remove-Item -Recurse -Force "$env:programdata\Microsoft OneDrive"
Remove-Item -Recurse -Force "$env:systemdrive\OneDriveTemp"

# check if directory is empty before removing:
If ((Get-ChildItem "$env:userprofile\OneDrive" -Recurse | Measure-Object).Count -eq 0) {
    Remove-Item -Recurse -Force "$env:userprofile\OneDrive"
}

$ErrorActionPreference = 'Continue'

# Disable OneDrive via Group Policies
New-FolderForced -Path "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive" "DisableFileSyncNGSC" 1

# Remove Onedrive from explorer sidebar
New-PSDrive -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" -Name "HKCR"
mkdir -Force "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
Set-ItemProperty -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0
mkdir -Force "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
Set-ItemProperty -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0
Remove-PSDrive "HKCR"

# Removing run hook for new users
. .\lib\load-reghelper.ps1
reg delete "HKLM\NewUser\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f

$ErrorActionPreference = 'SilentlyContinue'

Remove-Item -Force "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"
Get-ScheduledTask -TaskPath '\' -TaskName 'OneDrive*' | Unregister-ScheduledTask -Confirm:$false

# Start-Process 'explorer.exe'
Write-Host 'Uninstalled OneDrive'
