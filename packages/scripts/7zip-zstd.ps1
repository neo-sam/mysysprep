#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-Item -ea 0 '7z*-zstd-*.exe'

if ($GetMetadata) {
    return @{
        name   = '7zip-zstd'
        match  = $match
        ignore = Get-BooleanReturnFn (Test-Path 'C:\Program Files\7-Zip-Zstandard\7z.exe')
    }
}

Start-ProcessToInstall $match /S

# CUSTOM:

Add-SystemPath 'C:\Program Files\7-Zip-Zstandard'

Import-RegFile config\7zip-zstd.reg
Set-ItemPropertyWithDefaultUser `
    'HKCU:\Software\7-Zip-Zstandard\Options' `
    MenuIcons 1
