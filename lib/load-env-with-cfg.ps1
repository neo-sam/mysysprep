. .\config

foreach ($cfgfile in Get-ChildItem '.\config-*.ps1') {
    . $cfgfile
}

$Script:pkgCfgFolder = '.\modules\deploy\config'
