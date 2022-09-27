. .\_adminrequire.ps1
if (-not (Get-Module Appx -All -ListAvailable)) { exit }

Write-Host '==> Debloat Appx'

$ProgressPreference = 'SilentlyContinue'

foreach ($name in "$removeAppxList".Split("`n")) {
    if ($name -eq '') { continue }
    $app = Get-AppxPackage -Name $name
    if ($null -ne $app) {
        $app | Remove-AppxPackage
        Write-Host "Remove-AppxPackage $name [ok]"
    }
    $papp = Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $name
    if ($null -ne $app) {
        $papp | Remove-AppxProvisionedPackage -Online | Out-Null
        Write-Host "Remove-AppxProvisionedPackage $name [ok]"
    }
}

$ProgressPreference = 'Continue'
