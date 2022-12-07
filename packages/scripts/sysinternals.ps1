#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'SysinternalsSuite.zip'
$targetPath = 'C:\Program Files\Sysinternals'

if ($GetMetadata) {
    return @{
        name   = 'Sysinternals'
        match  = $match
        ignore = Get-BooleanReturnFn (Test-Path $targetPath)
    }
}

mkdir -f $targetPath >$null
Expand-Archive -Force $match $targetPath

# CUSTOM:

Push-Location $targetPath

Add-SystemPath .

# Get-ChildItem * -Exclude @() | Remove-Item

Get-ChildItem autologon*, tcpview*, winobj* |`
    Where-Object Extension -eq .exe |`
    Repair-HidpiCompatibility

Pop-Location

if (Get-ChildItem -ea 0 'VeraCrypt_Setup_x64_*.msi') {
    $it = New-Shortcut ($path = "C:\users\Default\Desktop\Autologon.lnk")
    $it.TargetPath = "$targetPath\Autologon.exe"
    $it.save()
    Copy-ToCurrentDesktop $path
}
