#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'workrave-win32-v*.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'Workrave'
        target = 'C:\Program Files (x86)\Workrave\lib\Workrave.exe'
    }
}

Start-Process -Wait $pkg '/SILENT /SUPPRESSMSGBOXES /NORESTART /SP-'

Set-ItemProperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run' Workrave 'C:\Program Files (x86)\Workrave\lib\Workrave.exe'

Set-HidpiMode 'C:\Program Files (x86)\Workrave\lib\Workrave.exe'

if (Test-Path ($it = 'config\workrave.reg')) {
    applyRegForMeAndDefault $it
}
