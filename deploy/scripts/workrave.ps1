#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'workrave-win32-v*.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'Workrave'
        target = 'C:\Program Files (x86)\Workrave\lib\Workrave.exe'
    }
}

Start-Process $pkg '/SILENT /SUPPRESSMSGBOXES /NORESTART /SP-' -PassThru | Wait-Process

Set-ItemProperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run' Workrave 'C:\Program Files (x86)\Workrave\lib\Workrave.exe'

Set-ItemProperty 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers' 'C:\Program Files (x86)\Workrave\lib\Workrave.exe' '~ HIGHDPIAWARE'

if (Test-Path ($it = 'config\workrave.reg')) {
    applyRegfileForMeAndDefault $it
}
