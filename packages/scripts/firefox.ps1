#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'Firefox Setup *.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'Firefox'
        target = 'C:\Program Files\Mozilla Firefox\firefox.exe'
    }
}

Start-Process -Wait $pkg '/S /DesktopShortcut=false'
