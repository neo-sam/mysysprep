. .\config
foreach ($cfgfile in Get-ChildItem .\config-*.ps1) {
    . $cfgfile
}
if (Test-Path .\modules\check-admin) {
    if (-not $env:IGNORE_ADMINREQUIRE) {
        .\modules\check-admin\main.ps1
    }
}
if (Test-Path .\modules\tweak-registry) {
    .\modules\tweak-registry\main.ps1
}
if (Test-Path .\modules\debloat) {
    .\modules\debloat\main.ps1
}
if (Test-Path .\modules\deploy-pkgs) {
    & '.\modules\deploy-pkgs\main.ps1'
}

pause
