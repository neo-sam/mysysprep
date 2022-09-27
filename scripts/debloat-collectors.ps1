. .\_adminrequire.ps1

Write-Host '==> Debloat System Data Collectors'

function Disable-BundledService {
    param([String[]]$names)
    $services = Get-Service $names | Where-Object { $_.StartType -ne 'Disabled' }
    $services | Stop-Service
    $services | Set-Service -StartupType Disabled
}

function Disable-BundledTask {
    param([String[]]$names)
    Get-ScheduledTask -TaskName $names | Disable-ScheduledTask -ErrorAction SilentlyContinue | Out-Null
}

if($protectMyUserData){
    Disable-BundledService dmwappushservice, DiagTrack
    Disable-BundledTask Consolidator, UsbCeip, DmClient, DmClientOnScenarioDownload
    Write-Host 'Disabled user data collectors.'
}

if ($disableUnusedServices) {
    Disable-BundledService PcaSvc, WerSvc
    Write-Host 'Disabled unused service.'
}

if ($uninstallXbox) {
    Disable-BundledService XblAuthManager, XblGameSave, XboxGipSvc, XboxNetApiSvc
    Disable-BundledTask XblGameSaveTask
    Write-Host 'Disabled Xbox service.'
}