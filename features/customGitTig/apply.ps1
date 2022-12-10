#Requires -RunAsAdministrator

$txt = Get-Content -Raw -ea 0 .tigrc
if (!$txt) { exit }

$txt | Out-FileUtf8NoBom ($a = 'C:\Users\Default\.tigrc')
if (!(Test-Path ($b = "$env:USERPROFILE\.tigrc"))) {
    Copy-Item $a $b
}
else {
    Write-MergeAdviceIfDifferent $a $b
}
