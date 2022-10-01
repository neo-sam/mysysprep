$pkgfile = Get-PackageFile "virtualbox-Win-latest.exe"
if (!$PSSenderInfo) {
    if ($pkgfile) { 'VirtualBox' }
    return
}

Start-Process $pkgfile '--silent' -PassThru | Wait-Process

Assert-Path "C:\Program Files\Oracle\VirtualBox\VirtualBox.exe"
