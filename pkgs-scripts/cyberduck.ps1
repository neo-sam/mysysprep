$pkgfile = Get-PackageFile "Cyberduck-Installer-*.exe"
if (!$PSSenderInfo) {
    if (-not $pkgfile) { return }
    return @{
        name   = 'Cyberduck'
        target = 'C:\Program Files\Cyberduck\Cyberduck.exe'
    }
}

Start-Process $pkgfile /quiet -PassThru | Wait-Process

reg.exe add 'HKLM\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers' /f /t REG_SZ /v 'C:\Program Files\Cyberduck\Cyberduck.exe' /d '~ HIGHDPIAWARE' >$null
