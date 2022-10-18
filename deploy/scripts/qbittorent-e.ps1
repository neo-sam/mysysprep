$pkg = Get-ChildItem -ea 0 'qbittorrent_enhanced_*_x64_setup.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'qBittorrent Enhanced'
        target = 'C:\Program Files\qBittorrent\qbittorrent.exe'
    }
}

Start-Process $pkg /S -PassThru | Wait-Process
