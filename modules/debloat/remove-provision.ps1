foreach ($name in "$removeAppxList".Split("`n")) {
    if ($name -eq '') { continue }
    $app = Get-AppxPackage -Name $name
    if ($null -ne $app) {
        $app | Remove-AppxPackage
        Write-Output "Remove-AppxPackage $name [ok]"
    }
    $papp = Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $name
    if ($null -ne $app) {
        $papp | Remove-AppxProvisionedPackage -Online | Out-Null
        Write-Output "Remove-AppxProvisionedPackage $name [ok]"
    }
}
