#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'gsudoSetup.msi'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'gsudo'
        target = 'C:\Program Files (x86)\gsudo\gsudo.exe'
        mutex  = 1
    }
}

Start-Process -Wait $pkg '/qb /norestart',
'/l*v log\gsudo.log'
