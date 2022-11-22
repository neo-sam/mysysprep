#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'SysinternalsSuite.zip'
$targetPath = "$env:SystemRoot\Sysinternals"

if ($GetMetadata) {
    return @{
        name   = 'Sysinternals'
        match  = $match
        ignore = if (Test-Path $targetPath) { { 1 } }else { { 0 } }
    }
}

$tmpdir = "$(mkdir -f "$env:TMP\win-sf\Sysinternals")"

Expand-Archive -Force $match $tmpdir

if ([Environment]::OSVersion.Version.Build -ge 10240) {
    $excludeList += 'desktops*'
}

Move-Item $tmpdir $env:SystemRoot

# CUSTOM:

Push-Location $targetPath

Add-SystemPath .

# Get-ChildItem * -Exclude @() | Remove-Item

Get-ChildItem autologon*, tcpview*, winobj* |`
    Where-Object Extension -eq .exe |`
    Repair-HidpiCompatibility

Pop-Location
