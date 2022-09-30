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
    Write-Output 'Disabled user data collectors.'
}

if ($disableUnusedServices) {
    Disable-BundledService PcaSvc, WerSvc
    Write-Output 'Disabled unused service.'
}

if ($uninstallXbox) {
    Disable-BundledService XblAuthManager, XblGameSave, XboxGipSvc, XboxNetApiSvc
    Disable-BundledTask XblGameSaveTask
    Write-Output 'Disabled Xbox service.'
}
