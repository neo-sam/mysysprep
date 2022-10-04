$pkgfile = Get-PackageFile "Cyberduck-Installer-*.exe"
if (!$PSSenderInfo) {
    if ($pkgfile) { 'Cyberduck' }
    return
}

Start-Process $pkgfile /quiet -PassThru | Wait-Process

Assert-Path "C:\Program Files\Cyberduck\Cyberduck.exe"

reg add 'HKLM\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers' /f /t REG_SZ /v 'C:\Program Files\Cyberduck\Cyberduck.exe' /d '~ HIGHDPIAWARE' >$null
