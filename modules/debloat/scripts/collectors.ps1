param(
    $privacy,
    $services,
    $xbox
)

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

if ($privacy) {
    $Script:msg = Get-Translation 'Disabled user data collectors.' `
        -cn '已屏蔽个人数据收集器'

    Disable-BundledService dmwappushservice, DiagTrack
    Disable-BundledTask Consolidator, UsbCeip, DmClient, DmClientOnScenarioDownload
    logif1
}

if ($services) {
    $Script:msg = Get-Translation 'Disabled unused service.' `
        -cn '已屏蔽无用的服务'

    Disable-BundledService PcaSvc, WerSvc
    logif1
}

if ($xbox) {
    $Script:msg = Get-Translation 'Disabled Xbox service.' `
        -cn '已屏蔽 Xbox 服务'

    Disable-BundledService XblAuthManager, XblGameSave, XboxGipSvc, XboxNetApiSvc
    Disable-BundledTask XblGameSaveTask
    logif1
}
