#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'SysinternalsSuite.zip'
$targetPath = 'C:\Program Files\Sysinternals'

if ($GetMetadata) {
    return @{
        name   = 'Sysinternals'
        match  = $match
        ignore = if (Test-Path $targetPath) { { 1 } } else { { 0 } }
    }
}

$tmpdir = "$(mkdir -f "$env:TMP\win-sf\Sysinternals")"

Expand-Archive -Force $match $tmpdir

if ([Environment]::OSVersion.Version.Build -ge 10240) {
    $excludeList += 'desktops*'
}

mkdir -f $targetPath >$null
Push-Location $tmpdir
Move-Item * $targetPath
Pop-Location

# CUSTOM:

Push-Location $targetPath

Add-SystemPath .

# Get-ChildItem * -Exclude @() | Remove-Item

Get-ChildItem autologon*, tcpview*, winobj* |`
    Where-Object Extension -eq .exe |`
    Repair-HidpiCompatibility

Pop-Location
