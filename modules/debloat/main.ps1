Write-Output '==> Debloat'

.\modules\debloat\disable-collectors.ps1

.\modules\debloat\remove-capabilities.ps1

if ($null -eq (Get-Module Appx -All -ListAvailable)) {
    $ProgressPreferenceBefore = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'
    .\modules\debloat\remove-provision.ps1
    $ProgressPreference = $ProgressPreferenceBefore
}
