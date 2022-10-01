$pkgfile = Get-PackageFile "VeraCrypt_Setup_x64_*.msi"
if (!$PSSenderInfo) {
    if ($pkgfile) { 'VeraCrypt', 'mutex' }
    return
}

Start-Process $pkgfile '/qb /norestart /l*v logs\veracrypt.log ACCEPTLICENSE=YES' -PassThru | Wait-Process

Assert-Path "C:\Program Files\VeraCrypt\VeraCrypt.exe"
