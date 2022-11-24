#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'platform-tools_r*-windows.zip'
$appdir = 'C:\Program Files\platform-tools'

if ($GetMetadata) {
    return @{
        name   = 'ADB'
        match  = $match
        ignore = if (Test-Path $appdir) { { 1 } } else { { 0 } }
    }
}

$tmpdir = "$(mkdir -f "$env:TMP\win-sf")"

Expand-Archive -Force $match $tmpdir
Move-Item $tmpdir\platform-tools 'C:\Program Files'
Add-SystemPath $appdir
