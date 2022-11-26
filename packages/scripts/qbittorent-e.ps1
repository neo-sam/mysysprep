#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'qbittorrent_enhanced_*_x64_setup.exe'

if ($GetMetadata) {
    return @{
        name   = 'qBittorrent Enhanced'
        match  = $match
        ignore = Get-BooleanReturnFn (Test-Path 'C:\Program Files\qBittorrent\qbittorrent.exe')
    }
}

Start-Process -Wait $match /S
