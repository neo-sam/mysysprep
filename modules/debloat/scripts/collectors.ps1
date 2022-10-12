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
        -base64cn 5bey5bGP6JS95Liq5Lq65pWw5o2u5pS26ZuG5ZmoCg==

    Disable-BundledService dmwappushservice, DiagTrack
    Disable-BundledTask Consolidator, UsbCeip, DmClient, DmClientOnScenarioDownload
    logif1
}

if ($services) {
    $Script:msg = Get-Translation 'Disabled unused service.' `
        -base64cn 5bey5bGP6JS95peg55So55qE5pyN5YqhCg==

    Disable-BundledService PcaSvc, WerSvc
    logif1
}

if ($xbox) {
    $Script:msg = Get-Translation 'Disabled Xbox service.' `
        -base64cn 5bey5bGP6JS9IFhib3gg5pyN5YqhCg==

    Disable-BundledService XblAuthManager, XblGameSave, XboxGipSvc, XboxNetApiSvc
    Disable-BundledTask XblGameSaveTask
    logif1
}
