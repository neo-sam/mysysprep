#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'vlc-*-win64.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'VLC'
        target = 'C:\Program Files\VideoLAN\VLC\vlc.exe'
    }
}

Start-Process $pkg /S -PassThru | Wait-Process
