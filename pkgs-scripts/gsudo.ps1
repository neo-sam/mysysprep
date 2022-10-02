$pkgfile = Get-PackageFile "gsudoSetup.msi"
if (!$PSSenderInfo) {
    if ($pkgfile) { 'gsudo', 'mutex' }
    return
}

Start-Process $pkgfile -PassThru '/qb /norestart',
'/l*v logs\gsudo.log' | Wait-Process

Assert-Path "C:\Program Files (x86)\gsudo\gsudo.exe"
