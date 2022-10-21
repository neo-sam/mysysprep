#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'Cyberduck-Installer-*.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'Cyberduck'
        target = 'C:\Program Files\Cyberduck\Cyberduck.exe'
    }
}

Start-Process $pkg /quiet -PassThru | Wait-Process

Set-ItemProperty 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers' 'C:\Program Files\Cyberduck\Cyberduck.exe' '~ HIGHDPIAWARE'
