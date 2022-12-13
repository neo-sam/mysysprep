#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-Item -ea 0 'Everything-*.x64.Lite-Setup.exe'
$appbin = 'C:\Program Files\Everything\Everything.exe'

if ($GetMetadata) {
    return @{
        name   = 'Everything'
        match  = $match
        ignore = Get-BooleanReturnFn (Test-Path $appbin)
    }
}

Start-ProcessToInstall $match /S

# CUSTOM:

Repair-HidpiCompatibility $appbin

if (Test-Path ($templ = 'config\Everything.ini')) {
    $target = "$(mkdir -f 'C:\Users\Default\AppData\Roaming\Everything')\Everything.ini"
    Get-Content $templ | Set-Content -Encoding oem $target
    if (!(Test-Path ($that = "$env:APPDATA\Everything\Everything.ini"))) {
        Copy-Item $target $that
    }
}

Move-DesktopIconFromPublicToDefaultAndCurrentUserIfAuditMode 'Everything'
