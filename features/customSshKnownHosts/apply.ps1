#Requires -RunAsAdministrator

$templateFile = Get-ChildItem known_hosts

Copy-Item $templateFile "$(mkdir -f C:\Users\Default\.ssh)"
if (!(Test-Path ($thisUserProfile = "$(mkdir -f $env:USERPROFILE\.ssh)\known_hosts"))) {
    Copy-Item $templateFile $thisUserProfile
}
else {
    Write-MergeAdviceIfDifferent $templateFile $thisUserProfile
}
