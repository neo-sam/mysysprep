$pkgfile = Get-PackageFile "gsudoSetup.msi"
if (!$PSSenderInfo) {
    if (-not $pkgfile) { return }
    return @{
        name  = 'gsudo'
        target = 'C:\Program Files (x86)\gsudo\gsudo.exe'
        mutex  = 1
    }
}

Start-Process $pkgfile -PassThru '/qb /norestart',
'/l*v logs\gsudo.log' | Wait-Process
