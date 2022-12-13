#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-Item -ea 0 'qbittorrent_*_setup.exe'

if ($GetMetadata) {
    return @{
        name   = 'qBittorrent'
        match  = $match
        ignore = Get-BooleanReturnFn (Test-Path 'C:\Program Files\qBittorrent\qbittorrent.exe')
    }
}

Start-ProcessToInstall $match '/NCRC /S'
