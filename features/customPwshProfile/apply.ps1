#Requires -RunAsAdministrator

if (Test-Path ($pwshDir = (Get-ChildItem 'C:\Program Files\PowerShell\*')[-1].FullName)) {
    if (!(Test-Path ($target = "$pwshDir\profile.ps1"))) {
        Set-Content -Encoding oem $target @'
if (Test-Path 'C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1') {
    . 'C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1'
}
Set-PSReadLineOption -PredictionSource History
'@
    }
}

Get-Content git-aliases.txt | Where-Object { !"$_".StartsWith('#') } | Out-File -Encoding ascii 'C:\Windows\System32\WindowsPowerShell\v1.0\git-aliases.txt'
if (!(Test-Path ($target = 'C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1'))) {
    Copy-Item .\profile.ps1 $target
}
else {
    Write-MergeAdviceIfDifferent -RunAsAdmin .\profile.ps1 $target
}
