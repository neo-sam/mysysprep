$pkgfile = Get-PackageFile "vlc-*-win64.exe"
if (!$PSSenderInfo) { 
    if ($pkgfile) { 'VLC' }
    return 
}

Start-Process $pkgfile /S -PassThru | Wait-Process

Assert-Path "C:\Program Files\VideoLAN\VLC\vlc.exe"