./_adminrequire
if (-not (Get-Module Appx -All -ListAvailable)) { exit }

Write-Host '==> Debloat Appx'
foreach ($name in $removeAppxList.Split("`n")) {
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