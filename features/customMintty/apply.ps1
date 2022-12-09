#Requires -RunAsAdministrator

$template = Get-Content -ea 0 -raw '.minttyrc'
if (!$template) { exit }

$result = $template
if ((Test-AppxSystemAvailable) -and (Get-AppxPackage Microsoft.WindowsTerminal)) {
    $result += 'Font=Cascadia Mono'
    $result += "`n"
}
$result | Out-FileUtf8NoBom ($referenceProfile = 'C:\Users\Default\.minttyrc')

if (!(Test-Path ($thisUserProfile = "$env:USERPROFILE\.minttyrc"))) {
    Copy-Item $referenceProfile $thisUserProfile
}
else {
    Write-MergeAdviceIfDifferent $referenceProfile $thisUserProfile
}
