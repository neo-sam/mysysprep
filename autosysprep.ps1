. .\config

foreach ($cfgfile in Get-ChildItem '.\config-*.ps1') {
    . $cfgfile
}

if (-not $env:IGNORE_ADMINREQUIRE) {
    . '.\lib\require-admin.ps1'
}

if (Test-Path '.\modules\tweak-system-registry') {
    & '.\modules\tweak-system-registry\main.ps1'
}
if (Test-Path '.\modules\debloat') {
    & '.\modules\debloat\main.ps1'
}
if (Test-Path '.\modules\deploy-pkgs') {
    & '.\modules\deploy-pkgs\main.ps1'
}

& '.\lib\submit-sysprep.ps1'
