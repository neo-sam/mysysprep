$pkgfile = Get-PackageFile "virtualbox-*win*.exe"
if (!$PSSenderInfo) {
    if (-not $pkgfile) { return }
    return @{
        name   = 'VirtualBox'
        target = 'C:\Program Files\Oracle\VirtualBox\VirtualBox.exe'
        mutex  = 1
    }
    return
}

Start-Process $pkgfile '--silent' -PassThru | Wait-Process

Push-SystemPath "C:\Program Files\Oracle\VirtualBox"
