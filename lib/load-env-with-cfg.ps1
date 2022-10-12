. .\config

foreach ($cfgfile in Get-ChildItem '.\config-*.ps1') {
    . $cfgfile
}
