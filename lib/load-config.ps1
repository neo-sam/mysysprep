. .\config

foreach ($cfgfile in Get-ChildItem '.\config-*.ps1') {
    . $cfgfile
}

if (Test-Path ($recfg = '.\config-rewrite.ps1')) {
    . $recfg
}
