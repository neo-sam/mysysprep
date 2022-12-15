$parts = (Get-Content "$PSScriptRoot\TaskbarLayoutModification.xml") -join "`n" -split "`n                <!-- data -->`n"

$lines = ''

function Add-App([string]$id) {
    $Script:lines += "                <taskbar:UWA AppUserModelID =`"$id!App`"/>`n"
}
function Add-Link([string]$path) {
    $Script:lines += "                <taskbar:DesktopApp DesktopApplicationLinkPath =`"$path`"/>`n"
}

function Test-DeployPackagePath([string]$path) {
    return Test-Path "$PSScriptRoot\..\packages\$path"
}

. $PSScriptRoot\generator_content.ps1

return ($parts[0], $lines.TrimEnd(), $parts[1]) -join "`n"
