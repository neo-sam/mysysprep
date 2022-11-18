#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'OBS-Studio-*-Full-Installer-x64.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'OBS'
        target = 'C:\Program Files\obs-studio\bin\64bit\obs64.exe'
    }
}

Start-Process -Wait $pkg '/NCRC /S'

# CUSTOM:

Remove-Item 'C:\Users\public\Desktop\OBS Studio.lnk'
