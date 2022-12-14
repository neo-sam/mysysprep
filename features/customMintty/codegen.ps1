Push-Location $PSScriptRoot

$template = Get-Content -ea 0 -raw '.minttyrc'
if (!$template) { exit }

$t = $template
$t = $t -replace '# (?=FontHeight=14)', ''
if ((Test-AppxSystemAvailable) -and (Get-AppxPackage Microsoft.WindowsTerminal)) {
    $t = $t -replace '# (?=Font=Cascadia Mono)', ''
}
$t

Pop-Location
