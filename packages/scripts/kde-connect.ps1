#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'kdeconnect-kde-*-windows-*.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'KDE Connect'
        target = 'C:\Program Files\KDE Connect\bin\kdeconnect-app.exe'
    }
}

Start-Process -Wait $pkg /S
