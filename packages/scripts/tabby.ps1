#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-Item -ea 0 'tabby-*-setup-*.exe'

if ($GetMetadata) {
    return @{
        name   = 'Tabby'
        match  = $match
        ignore = Get-BooleanReturnFn (Test-Path 'C:\Program Files\Tabby\Tabby.exe')
    }
}

Start-ProcessToInstall $match '/allusers /S'
