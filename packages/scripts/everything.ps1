#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'Everything-*.x64.Lite-Setup.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'Everything'
        target = 'C:\Program Files\Everything\Everything.exe'
    }
}

Start-Process -Wait $pkg /S

# CUSTOM:

if (Test-Path ($it = 'config\Everything.ini')) {
    if (!(Test-Path ($that = "$env:APPDATA\Everything\Everything.ini"))) {
        Copy-Item $it $that
    }
    Copy-Item $it (mkdir -f 'C:\Users\Default\AppData\Roaming\Everything')
}

Repair-HidpiCompatibility 'C:\Program Files\Everything\Everything.exe'
