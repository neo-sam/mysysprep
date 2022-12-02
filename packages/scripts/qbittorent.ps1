#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'qbittorrent_*_setup.exe'

if ($GetMetadata) {
    return @{
        name   = 'qBittorrent'
        match  = $match
        ignore = Get-BooleanReturnFn (Test-Path 'C:\Program Files\qBittorrent\qbittorrent.exe')
    }
}

Start-Process -Wait $match '/NCRC /S'
