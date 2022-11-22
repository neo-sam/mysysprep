#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'vlc-*-win64.exe'

if ($GetMetadata) {
    return @{
        name   = 'VLC'
        match  = $match
        ignore = { Test-Path 'C:\Program Files\VideoLAN\VLC\vlc.exe' }
    }
}

Start-Process -Wait $match /S
