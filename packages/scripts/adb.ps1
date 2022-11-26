#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'platform-tools_r*-windows.zip'
$appdir = 'C:\Program Files\platform-tools'

if ($GetMetadata) {
    return @{
        name   = 'ADB'
        match  = $match
        ignore = Get-BooleanReturnFn (Test-Path $appdir)
    }
}

$tmpdir = "$(mkdir -f "$env:TMP\win-sf")"

Expand-Archive -Force $match $tmpdir
Move-Item $tmpdir\platform-tools 'C:\Program Files'
icacls.exe 'C:\Program Files\platform-tools' /reset >$null
Add-SystemPath $appdir
