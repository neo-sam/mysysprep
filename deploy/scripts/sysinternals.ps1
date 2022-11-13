#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'SysinternalsSuite.zip'
$targetPath = "$env:SystemRoot\Sysinternals"
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'Sysinternals'
        target = $targetPath
    }
    return
}

$tmpdir = "$(mkdir -f "$env:TMP\win-sf\Sysinternals")"

Expand-Archive -Force $pkg $tmpdir

if ([Environment]::OSVersion.Version.Build -ge 10240) {
    $excludeList += 'desktops*'
}

Move-Item $tmpdir $env:SystemRoot

# CUSTOM:

Push-Location $targetPath

Push-SystemPath .

# Get-ChildItem * -Exclude @() | Remove-Item

Get-ChildItem autologon*, tcpview*, winobj* |`
    Where-Object Extension -eq .exe |`
    Repair-HidpiCompatibility

Pop-Location
