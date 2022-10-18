. .\config

foreach ($cfgfile in Get-ChildItem '.\config-*.ps1') {
    . $cfgfile
}

if (Test-Path ($recfg = '.\lib\debug\reconfig.ps1')) {
    . $recfg
}
