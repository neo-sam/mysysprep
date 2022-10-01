. .\config

foreach ($cfgfile in Get-ChildItem '.\config-*.ps1') {
    . $cfgfile
}

if (-not $env:IGNORE_ADMINREQUIRE) {
    . '.\lib\require-admin.ps1'
}

if (Test-Path '.\modules\tweak-registry') {
    & '.\modules\tweak-registry\main.ps1'
}
if (Test-Path '.\modules\debloat') {
    & '.\modules\debloat\main.ps1'
}
if (Test-Path '.\modules\deploy-pkgs-machine-level') {
    & '.\modules\deploy-pkgs-machine-level\main.ps1'
}
if (Test-Path '.\modules\deploy-pkgs-user-level') {
    & '.\modules\deploy-pkgs-user-level\main.ps1'
}

& '.\lib\submit-sysprep.ps1'
