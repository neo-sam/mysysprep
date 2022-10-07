$pkgfile = Get-PackageFile "qbittorrent_enhanced_*_x64_setup.exe"
if (!$PSSenderInfo) {
    if (-not $pkgfile) { return }
    return @{
        name   = 'qBittorrent Enhanced'
        target = 'C:\Program Files\qBittorrent\qbittorrent.exe'
    }
}

Start-Process $pkgfile /S -PassThru | Wait-Process
