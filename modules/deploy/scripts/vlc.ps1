$pkgfile = Get-PackageFile "vlc-*-win64.exe"
if (!$PSSenderInfo) {
    if (-not $pkgfile) { return }
    return @{
        name   = 'VLC'
        target = 'C:\Program Files\VideoLAN\VLC\vlc.exe'
    }
}

Start-Process $pkgfile /S -PassThru | Wait-Process
