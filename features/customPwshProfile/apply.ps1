#Requires -RunAsAdministrator

if ($pwshdirs = Get-ChildItem -ea 0 'C:\Program Files\PowerShell\*') {
    if (Test-Path ($pwshDir = $pwshdirs[-1].FullName)) {
        if (!(Test-Path ($target = "$pwshDir\profile.ps1"))) {
            Set-Content -Encoding oem $target @'
if (Test-Path 'C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1') {
    . 'C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1'
}
Set-PSReadLineOption -PredictionSource History
'@
        }
    }
}

if (!(Test-Path ($target = 'C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1'))) {
    Get-Content .\profile.ps1 | Out-File -Encoding oem $target
}
else {
    Write-MergeAdviceIfDifferent -RunAsAdmin .\profile.ps1 $target
}

$modulesdir = 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules'
if (Test-Path -PathType Container ($modname = 'GitToolsLoader')) {
    $target = "$modulesdir\$modname"
    mkdir -f $target | Out-Null
    Copy-Item $modname\$modname.psm1 $target

    $enableAliasesList = Get-Content "$modname\aliases.macro.txt" |`
        Where-Object { $_ -and !"$_".StartsWith('#') }

    $enableAliasesList | Out-File -Encoding ascii $target\aliases.txt
}
