$pkgfile = Get-PackageFile "qbittorrent_enhanced_*_x64_setup.exe"
if (!$PSSenderInfo) { 
    if ($pkgfile) { 'qBittorrent Enhanced' }
    return 
}

Start-Process $pkgfile /S -PassThru | Wait-Process

Assert-Path "C:\Program Files\qBittorrent\qbittorrent.exe"
