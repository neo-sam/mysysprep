$pkgfile = Get-PackageFile "VeraCrypt_Setup_x64_*.msi"
if (!$PSSenderInfo) {
    if (-not $pkgfile) { return }
    return @{
        name   = 'VeraCrypt'
        target = 'C:\Program Files\VeraCrypt\VeraCrypt.exe'
        mutex  = 1
    }
    return
}

Start-Process $pkgfile '/qb /norestart /l*v logs\veracrypt.log ACCEPTLICENSE=YES' -PassThru | Wait-Process
