Write-Host '==> Tweak the Registry'

if ($protectMyUserData) {
    reg import '.\modules\tweak-registry\protect-privacy.reg' 2>&1 | Out-Null
    Write-Host 'Disabled privacy collectors.'
}

if ($disableAd) {
    reg add HKLM\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo /f /t REG_DWORD /v Enabled /d 0 >$null
    Write-Host 'Disabled Ad.'
}

if ($optimzeExplorer) {
    reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer /v "Max Cached Icons" /t REG_SZ /d 16mb /f >$null
    Write-Host 'Optimized explorer.'
}

if ([Environment]::OSVersion.Version.Build -ge 22000) {
    if ($noTaskbarWidgets) {
        reg add HKLM\SOFTWARE\Policies\Microsoft\Dsh /v AllowNewsAndInterests /t REG_DWORD /f /d 0 >$null
        Write-Host 'Disabled Windows11 Widgets.'
    }
}
